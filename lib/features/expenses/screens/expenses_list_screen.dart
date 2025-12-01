import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/navigation_service.dart';
import 'package:amazinginventory/shared/widgets/search_bar.dart' as shared;
import '../models/expense_model.dart';
import '../data/mock_expense_repository.dart';
import '../widgets/expense_card.dart';

/// Expenses list screen
/// Implements clean architecture with separation of concerns
class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> _filteredExpenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final expenses = await MockExpenseRepository.getExpenses();
      setState(() {
        _expenses = expenses;
        _filteredExpenses = expenses;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading expenses: $e')),
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
        _filteredExpenses = _expenses;
      } else {
        final searchLower = searchQuery.toLowerCase();
        _filteredExpenses = _expenses.where((expense) {
          return expense.notes?.toLowerCase().contains(searchLower) ?? false;
        }).toList();
      }
    });
  }

  void _navigateToAddExpense() {
    // TODO: Navigate to add expense screen
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
                hintText: 'Search expenses...',
              ),
            ),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredExpenses.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadExpenses,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _filteredExpenses.length,
                            itemBuilder: (context, index) {
                              return ExpenseCard(
                                expense: _filteredExpenses[index],
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
                    'Expenses',
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
              onTap: _navigateToAddExpense,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: const Text(
                  'Add Expense',
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
          Icon(FeatherIcons.creditCard, size: 64, color: AppColors.gray400),
          const SizedBox(height: 16),
          Text(
            'No expenses found',
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
