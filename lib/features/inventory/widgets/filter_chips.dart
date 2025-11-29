import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Filter type enumeration
enum FilterType {
  totalStock,
  outOfStock,
  lowStock,
}

/// Filter chips widget for filtering inventory
class FilterChips extends StatelessWidget {
  final FilterType selectedFilter;
  final Function(FilterType) onFilterChanged;

  const FilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildFilterChip(
          label: 'Total Stock',
          filter: FilterType.totalStock,
          isSelected: selectedFilter == FilterType.totalStock,
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          label: 'Out of Stock',
          filter: FilterType.outOfStock,
          isSelected: selectedFilter == FilterType.outOfStock,
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          label: 'Low Stock',
          filter: FilterType.lowStock,
          isSelected: selectedFilter == FilterType.lowStock,
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required FilterType filter,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onFilterChanged(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.metricPurple : AppColors.gray100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

