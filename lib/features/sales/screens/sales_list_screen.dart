import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/navigation_service.dart';
import '../../../shared/utils/responsive_util.dart';
import 'package:amazinginventory/shared/widgets/search_bar.dart' as shared;
import '../models/sale_model.dart';
import '../data/mock_sale_repository.dart';
import '../widgets/sale_card.dart';

/// Sales list screen displaying all sales transactions
/// Implements clean architecture with separation of concerns
class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SaleModel> _sales = [];
  List<SaleModel> _filteredSales = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSales();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSales() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sales = await MockSaleRepository.getSales();
      setState(() {
        _sales = sales;
        _filteredSales = sales;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading sales: $e')),
        );
      }
    }
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final searchQuery = _searchController.text;
    setState(() {
      if (searchQuery.isEmpty) {
        _filteredSales = _sales;
      } else {
        final searchLower = searchQuery.toLowerCase();
        _filteredSales = _sales.where((sale) {
          return sale.customerName.toLowerCase().contains(searchLower);
        }).toList();
      }
    });
  }

  void _navigateToAddSale() {
    // TODO: Navigate to add sale screen
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBackground,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar
            _buildTopBar(),

            // Search
            Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveUtil.getHorizontalPadding(context),
                ResponsiveUtil.getSpacing(context),
                ResponsiveUtil.getHorizontalPadding(context),
                ResponsiveUtil.getSpacing(context) - 4,
              ),
              child: shared.AppSearchBar(
                controller: _searchController,
                hintText: 'Search sales...',
              ),
            ),

            // Sales List
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredSales.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadSales,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtil.getHorizontalPadding(
                                context,
                              ),
                            ),
                            itemCount: _filteredSales.length,
                            itemBuilder: (context, index) {
                              return SaleCard(sale: _filteredSales[index]);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final titleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 24);
    final buttonFontSize = ResponsiveUtil.getFontSize(context, baseSize: 14);
    final iconSize = ResponsiveUtil.getIconSize(context, baseSize: 24);
    final spacing = ResponsiveUtil.getSpacing(context);

    return Container(
      padding: ResponsiveUtil.getTopBarPadding(context),
      color: AppColors.cardBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      NavigationService.instance.onModuleChanged?.call(null);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(
                        ResponsiveUtil.isSmallScreen(context) ? 6 : 8,
                      ),
                      child: Icon(
                        FeatherIcons.arrowLeft,
                        color: AppColors.textPrimary,
                        size: iconSize,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing - 4),
                Flexible(
                  child: Text(
                    'Sales',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: AppColors.metricPurple,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: _navigateToAddSale,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtil.isSmallScreen(context) ? 12 : 16,
                  vertical: ResponsiveUtil.isSmallScreen(context) ? 8 : 10,
                ),
                child: Text(
                  'Add Sale',
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

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
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
          Icon(
            FeatherIcons.shoppingCart,
            size: iconSize,
            color: AppColors.gray400,
          ),
          SizedBox(height: spacing),
          Text(
            'No sales found',
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
