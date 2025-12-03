import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../shared/utils/responsive_util.dart';
import '../widgets/search_bar.dart' as inventory;
import '../widgets/filter_chips.dart';
import '../widgets/product_card.dart';
import '../models/product_model.dart';
import '../models/product_api_model.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import 'add_product_screen.dart';

/// Inventory screen displaying product list with search and filters
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> 
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  FilterType _selectedFilter = FilterType.totalStock;
  late final ProductCubit _productCubit;
  String? _currentSearch;
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    _productCubit = getIt<ProductCubit>();
    _searchController.addListener(_onSearchChanged);
    
    // Load products when screen is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasLoadedData) {
        _hasLoadedData = true;
        _productCubit.loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    // Don't close cubit - it's managed by service locator
    super.dispose();
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text.trim();
    // Debounce search - only search if query changed
    if (searchQuery != _currentSearch) {
      _currentSearch = searchQuery;
      _loadProductsWithFilters();
    }
  }

  void _loadProductsWithFilters() {
    final searchQuery = _searchController.text.trim();
    final isActive = _selectedFilter == FilterType.totalStock ? null : true;
    
    _productCubit.loadProducts(
      search: searchQuery.isEmpty ? null : searchQuery,
      isActive: isActive,
    );
  }

  void _onFilterChanged(FilterType filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _loadProductsWithFilters();
  }

  List<ProductModel> _filterProducts(List<ProductApiModel> apiProducts) {
    return apiProducts.map((apiProduct) {
      final product = ProductModel.fromApiModel(apiProduct);
      
      // Apply status filter
      switch (_selectedFilter) {
        case FilterType.totalStock:
          return product;
        case FilterType.outOfStock:
          return product.status == StockStatus.outOfStock ? product : null;
        case FilterType.lowStock:
          return product.status == StockStatus.lowStock ? product : null;
      }
    }).whereType<ProductModel>().toList();
  }

  void _navigateToAddProduct() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddProductScreen(),
        fullscreenDialog: false,
      ),
    );
    
    // Refresh product list if product was created successfully
    if (result == true && mounted) {
      _productCubit.loadProducts(
        search: _currentSearch,
        isActive: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return BlocProvider<ProductCubit>.value(
      value: _productCubit,
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: SafeArea(
              child: Column(
                children: [
                  // Top Bar
                  _buildTopBar(),

                  // Search and Filters
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      ResponsiveUtil.getHorizontalPadding(context),
                      ResponsiveUtil.getSpacing(context),
                      ResponsiveUtil.getHorizontalPadding(context),
                      ResponsiveUtil.getSpacing(context) - 4,
                    ),
                    child: Column(
                      children: [
                        inventory.InventorySearchBar(
                          controller: _searchController,
                          hintText: 'Search products...',
                        ),
                        SizedBox(height: ResponsiveUtil.getSpacing(context)),
                        FilterChips(
                          selectedFilter: _selectedFilter,
                          onFilterChanged: _onFilterChanged,
                        ),
                      ],
                    ),
                  ),

                  // Product List
                  Expanded(
                    child: _buildProductList(state),
                  ),
                ],
              ),
            ),
            // Bottom navigation is handled by main app
          );
        },
      ),
    );
  }

  Widget _buildProductList(ProductState state) {
    if (state is ProductLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is ProductError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FeatherIcons.alertCircle,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading products',
              style: TextStyle(
                fontSize: ResponsiveUtil.getFontSize(context, baseSize: 18),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(
                fontSize: ResponsiveUtil.getFontSize(context, baseSize: 14),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _productCubit.loadProducts(),
              icon: const Icon(FeatherIcons.refreshCw),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.metricPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (state is ProductLoaded) {
      final filteredProducts = _filterProducts(state.products);
      
      if (filteredProducts.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: () async {
          _productCubit.refresh();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtil.getHorizontalPadding(context),
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            return ProductCard(product: filteredProducts[index]);
          },
        ),
      );
    }

    // Initial state
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildTopBar() {
    final titleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 24);
    final buttonFontSize = ResponsiveUtil.getFontSize(context, baseSize: 14);

    return Container(
      padding: ResponsiveUtil.getTopBarPadding(context),
      color: AppColors.cardBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Inventory',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Material(
            color: AppColors.metricPurple,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: _navigateToAddProduct,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtil.isSmallScreen(context) ? 12 : 16,
                  vertical: ResponsiveUtil.isSmallScreen(context) ? 8 : 10,
                ),
                child: Text(
                  'Add Product',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final iconSize = ResponsiveUtil.getContainerSize(context, baseSize: 64);
    final titleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 18);
    final subtitleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 14);
    final spacing = ResponsiveUtil.getSpacing(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FeatherIcons.package, size: iconSize, color: AppColors.gray400),
          SizedBox(height: spacing),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: spacing - 4),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtil.getHorizontalPadding(context),
            ),
            child: Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: subtitleFontSize,
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
