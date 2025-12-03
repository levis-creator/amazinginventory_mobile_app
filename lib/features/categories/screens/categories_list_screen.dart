import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/di/service_locator.dart';
import 'package:amazinginventory/shared/widgets/search_bar.dart' as shared;
import '../../../shared/widgets/add_category_modal.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';
import '../widgets/category_card.dart';

/// Categories list screen
/// Implements clean architecture with separation of concerns
class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CategoryCubit _categoryCubit = getIt<CategoryCubit>();
  String? _currentSearch;
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // Load categories when screen is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasLoadedData) {
        _hasLoadedData = true;
        _categoryCubit.loadCategories();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text.trim();
    if (searchQuery != _currentSearch) {
      _currentSearch = searchQuery.isEmpty ? null : searchQuery;
      _categoryCubit.loadCategories(
        search: _currentSearch,
      );
    }
  }

  Future<void> _refreshCategories() async {
    await _categoryCubit.loadCategories(
      search: _currentSearch,
    );
  }

  void _navigateToAddCategory() {
    showDialog(
      context: context,
      builder: (context) => AddCategoryModal(
        onCategoryAdded: (category) {
          // Refresh categories from backend after adding
          _refreshCategories();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryCubit>.value(
      value: _categoryCubit,
      child: Material(
        color: AppColors.scaffoldBackground,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildTopBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: shared.AppSearchBar(
                  controller: _searchController,
                  hintText: 'Search categories...',
                ),
              ),
              Expanded(
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => _buildLoadingState(),
                      loading: () => _buildLoadingState(),
                      loaded: (categories, paginationMeta, paginationLinks) {
                        if (categories.isEmpty) {
                          return _buildEmptyState();
                        }
                        return RefreshIndicator(
                          onRefresh: _refreshCategories,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                category: categories[index],
                              );
                            },
                          ),
                        );
                      },
                      error: (message) => _buildErrorState(message),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        FeatherIcons.arrowLeft,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24,
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
              onTap: _navigateToAddCategory,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: const Text(
                  'Add Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FeatherIcons.tag, size: 64, color: AppColors.gray400),
          const SizedBox(height: 16),
          Text(
            'No categories found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentSearch != null
                ? 'Try adjusting your search'
                : 'Create your first category to get started',
            style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
              'Error loading categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshCategories,
              icon: const Icon(FeatherIcons.refreshCw),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.metricPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
