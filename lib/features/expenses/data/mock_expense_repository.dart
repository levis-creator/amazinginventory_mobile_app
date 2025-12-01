import '../models/expense_model.dart';

/// Mock repository for expense data.
/// 
/// Provides sample expense data matching the Laravel API structure.
/// This is used for development and testing when the API is not available.
class MockExpenseRepository {
  /// Returns a list of sample expenses.
  /// 
  /// This method provides mock data that matches the API response format.
  /// In production, this should be replaced with actual API calls.
  static Future<List<ExpenseModel>> getExpenses({
    String? search,
    int? expenseCategoryId,
    String? dateFrom,
    String? dateTo,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var expenses = _mockExpenses;

    // Apply filters
    if (search != null && search.isNotEmpty) {
      final searchLower = search.toLowerCase();
      expenses = expenses.where((expense) {
        return expense.notes?.toLowerCase().contains(searchLower) ?? false;
      }).toList();
    }

    if (expenseCategoryId != null) {
      expenses = expenses.where((expense) => expense.expenseCategoryId == expenseCategoryId).toList();
    }

    if (dateFrom != null) {
      final fromDate = DateTime.parse(dateFrom);
      expenses = expenses.where((expense) {
        final expenseDate = DateTime.parse(expense.date);
        return expenseDate.isAfter(fromDate) || expenseDate.isAtSameMomentAs(fromDate);
      }).toList();
    }

    if (dateTo != null) {
      final toDate = DateTime.parse(dateTo);
      expenses = expenses.where((expense) {
        final expenseDate = DateTime.parse(expense.date);
        return expenseDate.isBefore(toDate) || expenseDate.isAtSameMomentAs(toDate);
      }).toList();
    }

    return expenses;
  }

  /// Returns a single expense by ID.
  static Future<ExpenseModel?> getExpenseById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockExpenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock expenses data matching API structure.
  static final List<ExpenseModel> _mockExpenses = [
    ExpenseModel(
      id: 1,
      expenseCategoryId: 1,
      expenseCategory: ExpenseCategoryInfo(
        id: 1,
        name: 'Bale Purchase',
        description: 'Auto-created expense category for purchase orders',
      ),
      amount: '9000.00',
      notes: 'Auto-created expense for Purchase #1',
      date: DateTime.now().subtract(const Duration(days: 10)).toIso8601String().split('T')[0],
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      purchaseId: 1,
      purchase: PurchaseInfo(id: 1, totalAmount: 9000.00),
      stockMovementId: null,
      stockMovement: null,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ExpenseModel(
      id: 2,
      expenseCategoryId: 2,
      expenseCategory: ExpenseCategoryInfo(
        id: 2,
        name: 'Transport',
        description: 'Transportation expenses',
      ),
      amount: '300.00',
      notes: 'Transport cost for delivery',
      date: DateTime.now().subtract(const Duration(days: 10)).toIso8601String().split('T')[0],
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      purchaseId: 1,
      purchase: PurchaseInfo(id: 1, totalAmount: 9000.00),
      stockMovementId: null,
      stockMovement: null,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ExpenseModel(
      id: 3,
      expenseCategoryId: 1,
      expenseCategory: ExpenseCategoryInfo(
        id: 1,
        name: 'Bale Purchase',
        description: 'Auto-created expense category for purchase orders',
      ),
      amount: '800.00',
      notes: 'Auto-created expense for Purchase #2',
      date: DateTime.now().subtract(const Duration(days: 7)).toIso8601String().split('T')[0],
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      purchaseId: 2,
      purchase: PurchaseInfo(id: 2, totalAmount: 800.00),
      stockMovementId: null,
      stockMovement: null,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    ExpenseModel(
      id: 4,
      expenseCategoryId: 1,
      expenseCategory: ExpenseCategoryInfo(
        id: 1,
        name: 'Bale Purchase',
        description: 'Auto-created expense category for purchase orders',
      ),
      amount: '2500.00',
      notes: 'Auto-created expense for Purchase #3',
      date: DateTime.now().subtract(const Duration(days: 4)).toIso8601String().split('T')[0],
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      purchaseId: 3,
      purchase: PurchaseInfo(id: 3, totalAmount: 2500.00),
      stockMovementId: null,
      stockMovement: null,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    ExpenseModel(
      id: 5,
      expenseCategoryId: 3,
      expenseCategory: ExpenseCategoryInfo(
        id: 3,
        name: 'Packaging',
        description: 'Packaging materials and supplies',
      ),
      amount: '100.00',
      notes: 'Packaging materials',
      date: DateTime.now().subtract(const Duration(days: 4)).toIso8601String().split('T')[0],
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      purchaseId: 3,
      purchase: PurchaseInfo(id: 3, totalAmount: 2500.00),
      stockMovementId: null,
      stockMovement: null,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    ExpenseModel(
      id: 6,
      expenseCategoryId: 4,
      expenseCategory: ExpenseCategoryInfo(
        id: 4,
        name: 'Rent',
        description: 'Rental expenses for facilities',
      ),
      amount: '2000.00',
      notes: 'Monthly rent payment',
      date: DateTime.now().subtract(const Duration(days: 3)).toIso8601String().split('T')[0],
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      purchaseId: null,
      purchase: null,
      stockMovementId: null,
      stockMovement: null,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ExpenseModel(
      id: 7,
      expenseCategoryId: 5,
      expenseCategory: ExpenseCategoryInfo(
        id: 5,
        name: 'Electricity',
        description: 'Electricity and utility bills',
      ),
      amount: '150.00',
      notes: 'Monthly electricity bill',
      date: DateTime.now().subtract(const Duration(days: 2)).toIso8601String().split('T')[0],
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      purchaseId: null,
      purchase: null,
      stockMovementId: null,
      stockMovement: null,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ExpenseModel(
      id: 8,
      expenseCategoryId: 6,
      expenseCategory: ExpenseCategoryInfo(
        id: 6,
        name: 'Salary',
        description: 'Employee salaries and wages',
      ),
      amount: '5000.00',
      notes: 'Monthly staff salaries',
      date: DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0],
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      purchaseId: null,
      purchase: null,
      stockMovementId: null,
      stockMovement: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ExpenseModel(
      id: 9,
      expenseCategoryId: 7,
      expenseCategory: ExpenseCategoryInfo(
        id: 7,
        name: 'Marketing',
        description: 'Marketing and advertising expenses',
      ),
      amount: '500.00',
      notes: 'Social media advertising campaign',
      date: DateTime.now().toIso8601String().split('T')[0],
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      purchaseId: null,
      purchase: null,
      stockMovementId: null,
      stockMovement: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
}

