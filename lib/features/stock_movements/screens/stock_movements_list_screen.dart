import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/navigation_service.dart';
import 'package:amazinginventory/shared/widgets/search_bar.dart' as shared;
import '../models/stock_movement_model.dart';
import '../data/mock_stock_movement_repository.dart';
import '../widgets/stock_movement_card.dart';

/// Stock movements list screen
/// Implements clean architecture with separation of concerns
class StockMovementsListScreen extends StatefulWidget {
  const StockMovementsListScreen({super.key});

  @override
  State<StockMovementsListScreen> createState() =>
      _StockMovementsListScreenState();
}

class _StockMovementsListScreenState extends State<StockMovementsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<StockMovementModel> _movements = [];
  List<StockMovementModel> _filteredMovements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovements();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMovements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final movements = await MockStockMovementRepository.getStockMovements();
      setState(() {
        _movements = movements;
        _filteredMovements = movements;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading stock movements: $e')),
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
        _filteredMovements = _movements;
      } else {
        final searchLower = searchQuery.toLowerCase();
        _filteredMovements = _movements.where((movement) {
          return (movement.product?.name.toLowerCase().contains(searchLower) ?? false) ||
              (movement.product?.sku.toLowerCase().contains(searchLower) ?? false) ||
              movement.reason.toLowerCase().contains(searchLower) ||
              (movement.notes?.toLowerCase().contains(searchLower) ?? false);
        }).toList();
      }
    });
  }

  void _navigateToAddMovement() {
    // TODO: Navigate to add movement screen
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
                hintText: 'Search stock movements...',
              ),
            ),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredMovements.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadMovements,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _filteredMovements.length,
                            itemBuilder: (context, index) {
                              return StockMovementCard(
                                movement: _filteredMovements[index],
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
                    'Stock Movements',
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
              onTap: _navigateToAddMovement,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: const Text(
                  'Add Movement',
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
          Icon(FeatherIcons.trendingUp, size: 64, color: AppColors.gray400),
          const SizedBox(height: 16),
          Text(
            'No movements found',
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
