import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../models/module_item.dart';
import '../widgets/module_list_item.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/navigation_service.dart';
import '../../../shared/utils/responsive_util.dart';
import 'package:amazinginventory/shared/widgets/search_bar.dart' as shared;

/// Modules list screen displaying all available inventory management modules
/// Implements clean architecture with separation of concerns
class ModulesListScreen extends StatefulWidget {
  const ModulesListScreen({super.key});

  @override
  State<ModulesListScreen> createState() => _ModulesListScreenState();
}

class _ModulesListScreenState extends State<ModulesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ModuleItem> _filteredModules = [];

  // Module definitions with colors and metadata
  final List<ModuleItem> _modules = [
    ModuleItem(
      id: 'sales',
      title: 'Sales',
      subtitle: 'View and manage all sales transactions',
      icon: FeatherIcons.shoppingCart,
      color: const Color(0xFF2196F3),
      backgroundColor: const Color(0xFFE3F2FD),
      route: '/sales',
      apiEndpoint: 'sales',
    ),
    ModuleItem(
      id: 'purchases',
      title: 'Purchases',
      subtitle: 'Track purchase orders and inventory restocking',
      icon: FeatherIcons.shoppingBag,
      color: const Color(0xFF9C27B0),
      backgroundColor: const Color(0xFFF3E5F5),
      route: '/purchases',
      apiEndpoint: 'purchases',
    ),
    ModuleItem(
      id: 'capital',
      title: 'Capital Investments',
      subtitle: 'Monitor capital investments and funding',
      icon: FeatherIcons.dollarSign,
      color: const Color(0xFF4CAF50),
      backgroundColor: const Color(0xFFE8F5E9),
      route: '/capital',
      apiEndpoint: 'capital-investments',
    ),
    ModuleItem(
      id: 'expenses',
      title: 'Expenses',
      subtitle: 'Track business expenses and costs',
      icon: FeatherIcons.creditCard,
      color: const Color(0xFFF44336),
      backgroundColor: const Color(0xFFFFEBEE),
      route: '/expenses',
      apiEndpoint: 'expenses',
    ),
    ModuleItem(
      id: 'expense_categories',
      title: 'Expense Categories',
      subtitle: 'Organize expenses by category',
      icon: FeatherIcons.folder,
      color: const Color(0xFFFF9800),
      backgroundColor: const Color(0xFFFFF3E0),
      route: '/expense-categories',
      apiEndpoint: 'expense-categories',
    ),
    ModuleItem(
      id: 'categories',
      title: 'Categories',
      subtitle: 'Organize products by category',
      icon: FeatherIcons.tag,
      color: const Color(0xFF00BCD4),
      backgroundColor: const Color(0xFFE0F7FA),
      route: '/categories',
      apiEndpoint: 'categories',
    ),
    ModuleItem(
      id: 'suppliers',
      title: 'Suppliers',
      subtitle: 'Manage supplier information',
      icon: FeatherIcons.truck,
      color: const Color(0xFF795548),
      backgroundColor: const Color(0xFFEFEBE9),
      route: '/suppliers',
      apiEndpoint: 'suppliers',
    ),
    ModuleItem(
      id: 'stock_movements',
      title: 'Stock Movements',
      subtitle: 'Track inventory stock changes',
      icon: FeatherIcons.trendingUp,
      color: const Color(0xFF607D8B),
      backgroundColor: const Color(0xFFECEFF1),
      route: '/stock-movements',
      apiEndpoint: 'stock-movements',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredModules = _modules;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredModules = _modules.where((module) {
        return module.title.toLowerCase().contains(query) ||
            module.subtitle.toLowerCase().contains(query);
      }).toList();
    });
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
                hintText: 'Search modules...',
              ),
            ),

            // Modules List
            Expanded(
              child: _filteredModules.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: EdgeInsets.all(
                        ResponsiveUtil.getHorizontalPadding(context),
                      ),
                      children: _filteredModules.map((module) {
                        return ModuleListItem(
                          module: module,
                          onTap: () => _navigateToModule(module),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final titleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 24);

    return Container(
      padding: ResponsiveUtil.getTopBarPadding(context),
      color: AppColors.cardBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Modules',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          // Placeholder to maintain consistent layout with other screens
          SizedBox(width: ResponsiveUtil.isSmallScreen(context) ? 60 : 80),
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
          Icon(FeatherIcons.grid, size: iconSize, color: AppColors.gray400),
          SizedBox(height: spacing),
          Text(
            'No modules found',
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

  void _navigateToModule(ModuleItem module) {
    // Map module ID to AppConstants module identifier
    final moduleId = _getModuleId(module.id);

    if (moduleId != null) {
      // Use NavigationService to navigate to module screen
      // This keeps the bottom navigation bar visible
      NavigationService.instance.navigateToModule(moduleId);
    }
  }

  /// Maps module item ID to AppConstants module identifier.
  ///
  /// Returns the corresponding AppConstants module identifier or null if not found.
  String? _getModuleId(String moduleItemId) {
    switch (moduleItemId) {
      case 'sales':
        return AppConstants.moduleSales;
      case 'purchases':
        return AppConstants.modulePurchases;
      case 'capital':
        return AppConstants.moduleCapital;
      case 'expenses':
        return AppConstants.moduleExpenses;
      case 'expense_categories':
        return AppConstants.moduleExpenseCategories;
      case 'categories':
        return AppConstants.moduleCategories;
      case 'suppliers':
        return AppConstants.moduleSuppliers;
      case 'stock_movements':
        return AppConstants.moduleStockMovements;
      case 'products':
        return AppConstants.moduleProducts;
      default:
        return null;
    }
  }
}
