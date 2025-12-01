import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/navigation_service.dart';
import 'package:amazinginventory/shared/widgets/search_bar.dart' as shared;
import '../models/supplier_model.dart';
import '../data/mock_supplier_repository.dart';
import '../widgets/supplier_card.dart';

/// Suppliers list screen
/// Implements clean architecture with separation of concerns
class SuppliersListScreen extends StatefulWidget {
  const SuppliersListScreen({super.key});

  @override
  State<SuppliersListScreen> createState() => _SuppliersListScreenState();
}

class _SuppliersListScreenState extends State<SuppliersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SupplierModel> _suppliers = [];
  List<SupplierModel> _filteredSuppliers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSuppliers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final suppliers = await MockSupplierRepository.getSuppliers();
      setState(() {
        _suppliers = suppliers;
        _filteredSuppliers = suppliers;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading suppliers: $e')),
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
        _filteredSuppliers = _suppliers;
      } else {
        final searchLower = searchQuery.toLowerCase();
        _filteredSuppliers = _suppliers.where((supplier) {
          return supplier.name.toLowerCase().contains(searchLower) ||
              (supplier.contact?.toLowerCase().contains(searchLower) ?? false) ||
              (supplier.email?.toLowerCase().contains(searchLower) ?? false) ||
              (supplier.address?.toLowerCase().contains(searchLower) ?? false);
        }).toList();
      }
    });
  }

  void _navigateToAddSupplier() {
    // TODO: Navigate to add supplier screen
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
                hintText: 'Search suppliers...',
              ),
            ),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredSuppliers.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadSuppliers,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _filteredSuppliers.length,
                            itemBuilder: (context, index) {
                              return SupplierCard(
                                supplier: _filteredSuppliers[index],
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
                    'Suppliers',
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
              onTap: _navigateToAddSupplier,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: const Text(
                  'Add Supplier',
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
          Icon(FeatherIcons.truck, size: 64, color: AppColors.gray400),
          const SizedBox(height: 16),
          Text(
            'No suppliers found',
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
