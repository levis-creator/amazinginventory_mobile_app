import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/responsive_util.dart';
import '../widgets/search_bar.dart' as inventory;
import '../widgets/filter_chips.dart';
import '../widgets/product_card.dart';
import '../models/product_model.dart';
import 'add_product_screen.dart';

/// Inventory screen displaying product list with search and filters
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  FilterType _selectedFilter = FilterType.totalStock;
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    setState(() {
      _products = ProductModel.getSampleProducts();
      _filteredProducts = _products;
      _applyFilters();
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    String searchQuery = _searchController.text.toLowerCase();

    setState(() {
      _filteredProducts = _products.where((product) {
        // Search filter
        bool matchesSearch =
            product.name.toLowerCase().contains(searchQuery) ||
            product.sku.toLowerCase().contains(searchQuery);

        if (!matchesSearch) return false;

        // Status filter
        switch (_selectedFilter) {
          case FilterType.totalStock:
            return true;
          case FilterType.outOfStock:
            return product.status == StockStatus.outOfStock;
          case FilterType.lowStock:
            return product.status == StockStatus.lowStock;
        }
      }).toList();
    });
  }

  void _onFilterChanged(FilterType filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilters();
    });
  }

  void _navigateToAddProduct() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddProductScreen(),
        fullscreenDialog: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: _filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtil.getHorizontalPadding(
                          context,
                        ),
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: _filteredProducts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      // Bottom navigation is handled by main app
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
