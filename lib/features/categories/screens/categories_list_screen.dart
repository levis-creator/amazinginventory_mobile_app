import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/navigation_service.dart';
import 'package:amazinginventory/shared/widgets/search_bar.dart' as shared;
import '../../../shared/widgets/add_category_modal.dart';
import '../models/category_model.dart';
import '../data/mock_category_repository.dart';
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
  List<CategoryModel> _categories = [];
  List<CategoryModel> _filteredCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await MockCategoryRepository.getCategories();
      setState(() {
        _categories = categories;
        _filteredCategories = categories;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading categories: $e')),
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
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories.where((category) {
          final searchLower = searchQuery.toLowerCase();
          return category.name.toLowerCase().contains(searchLower) ||
              (category.description?.toLowerCase().contains(searchLower) ?? false);
        }).toList();
      }
    });
  }

  void _navigateToAddCategory() {
    showDialog(
      context: context,
      builder: (context) => AddCategoryModal(
        onCategoryAdded: (category) {
          setState(() {
            _categories.add(category);
            _filteredCategories.add(category);
          });
          // Optionally reload from API to get the full list
          _loadCategories();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredCategories.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadCategories,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _filteredCategories.length,
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                category: _filteredCategories[index],
                              );
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
            'Try adjusting your search or filters',
            style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
