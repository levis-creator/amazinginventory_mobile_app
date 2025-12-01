# Mock Data Layer - Implementation Summary

This document summarizes the mock data layer implementation for the Flutter app, based on the Laravel backend API structure.

## ✅ Completed Modules

### 1. **Categories Module**
- **Model**: `lib/features/categories/models/category_model.dart`
- **Mock Repository**: `lib/features/categories/data/mock_category_repository.dart`
- **Features**: CRUD operations, search, active/inactive filtering
- **Sample Data**: 7 categories (Electronics, Accessories, Clothing, etc.)

### 2. **Suppliers Module**
- **Model**: `lib/features/suppliers/models/supplier_model.dart`
- **Mock Repository**: `lib/features/suppliers/data/mock_supplier_repository.dart`
- **Features**: CRUD operations, search by name/contact/email/address
- **Sample Data**: 6 suppliers with contact information

### 3. **Products Module**
- **API Model**: `lib/features/inventory/models/product_api_model.dart` (matches Laravel API)
- **Mock Repository**: `lib/features/inventory/data/mock_product_repository.dart`
- **Features**: CRUD operations, category filtering, active status, search by name/SKU
- **Sample Data**: 7 products with categories, prices, and stock levels
- **Note**: Original `product_model.dart` kept for UI compatibility

### 4. **Stock Movements Module**
- **Model**: `lib/features/stock_movements/models/stock_movement_model.dart`
- **Mock Repository**: `lib/features/stock_movements/data/mock_stock_movement_repository.dart`
- **Features**: List movements, filter by product/type/reason
- **Sample Data**: 10 stock movements (in/out, purchase/sale/adjustment)

### 5. **Purchases Module**
- **Model**: `lib/features/purchases/models/purchase_model.dart`
- **Mock Repository**: `lib/features/purchases/data/mock_purchase_repository.dart`
- **Features**: Purchase orders with items and expenses
- **Sample Data**: 5 purchases with items, suppliers, and linked expenses

### 6. **Sales Module**
- **Model**: `lib/features/sales/models/sale_model.dart`
- **Mock Repository**: `lib/features/sales/data/mock_sale_repository.dart`
- **Features**: Sales transactions with items
- **Sample Data**: 6 sales with customer names and product items

### 7. **Expense Categories Module**
- **Model**: `lib/features/expense_categories/models/expense_category_model.dart`
- **Mock Repository**: `lib/features/expense_categories/data/mock_expense_category_repository.dart`
- **Features**: CRUD operations, active status filtering
- **Sample Data**: 10 expense categories (Bale Purchase, Transport, Rent, etc.)

### 8. **Expenses Module**
- **Model**: `lib/features/expenses/models/expense_model.dart`
- **Mock Repository**: `lib/features/expenses/data/mock_expense_repository.dart`
- **Features**: Expense entries, date range filtering, category filtering
- **Sample Data**: 9 expenses (linked to purchases and standalone)

### 9. **Authentication Module**
- **Model**: `lib/features/auth/models/user_model.dart`
- **Mock Repository**: `lib/features/auth/data/mock_auth_repository.dart`
- **Features**: Login, register, logout, get user, permissions, permission checking
- **Sample Data**: Mock user with admin role and permissions

## 📁 File Structure

```
lib/
├── features/
│   ├── auth/
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   └── data/
│   │       └── mock_auth_repository.dart
│   ├── categories/
│   │   ├── models/
│   │   │   └── category_model.dart
│   │   └── data/
│   │       └── mock_category_repository.dart
│   ├── suppliers/
│   │   ├── models/
│   │   │   └── supplier_model.dart
│   │   └── data/
│   │       └── mock_supplier_repository.dart
│   ├── inventory/
│   │   ├── models/
│   │   │   ├── product_model.dart (existing)
│   │   │   └── product_api_model.dart (new, API-compatible)
│   │   └── data/
│   │       └── mock_product_repository.dart
│   ├── stock_movements/
│   │   ├── models/
│   │   │   └── stock_movement_model.dart
│   │   └── data/
│   │       └── mock_stock_movement_repository.dart
│   ├── purchases/
│   │   ├── models/
│   │   │   └── purchase_model.dart
│   │   └── data/
│   │       └── mock_purchase_repository.dart
│   ├── sales/
│   │   ├── models/
│   │   │   └── sale_model.dart
│   │   └── data/
│   │       └── mock_sale_repository.dart
│   ├── expense_categories/
│   │   ├── models/
│   │   │   └── expense_category_model.dart
│   │   └── data/
│   │       └── mock_expense_category_repository.dart
│   └── expenses/
│       ├── models/
│       │   └── expense_model.dart
│       └── data/
│           └── mock_expense_repository.dart
└── core/
    └── data/
        └── mock_data_documentation.md
```

## 🎯 Key Features

### 1. **API Compatibility**
- All models match Laravel API Resource structures exactly
- Field names use snake_case as in API (converted to camelCase in models)
- Data types match API responses (int, double, String, bool, DateTime)

### 2. **JSON Serialization**
- Every model includes `fromJson()` factory constructor
- Every model includes `toJson()` method
- Proper handling of nullable fields and nested objects

### 3. **Network Simulation**
- All mock repository methods simulate network delays
- Delays: 300ms (single items), 500ms (lists), 800ms+ (auth operations)

### 4. **Filtering Support**
- Search functionality matches API behavior
- Multiple filter combinations supported
- Filter parameters match API query parameters

### 5. **Realistic Data**
- Mock data includes realistic relationships
- Dates are relative to current time
- Referential integrity maintained (e.g., product IDs in purchases match products)

## 📖 Usage Examples

### Categories
```dart
// Get all categories
final categories = await MockCategoryRepository.getCategories();

// Get filtered categories
final filtered = await MockCategoryRepository.getCategories(
  search: 'electronics',
  isActive: true,
);
```

### Products
```dart
// Get all products
final products = await MockProductRepository.getProducts();

// Get products with filters
final filtered = await MockProductRepository.getProducts(
  search: 'laptop',
  categoryId: 1,
  isActive: true,
);
```

### Authentication
```dart
// Login
final authResponse = await MockAuthRepository.login(
  email: 'john@example.com',
  password: 'password123',
);

// Get current user
final user = await MockAuthRepository.getCurrentUser();

// Check permission
final hasPermission = await MockAuthRepository.checkPermission('view users');
```

### Purchases
```dart
// Get all purchases
final purchases = await MockPurchaseRepository.getPurchases();

// Get purchases by supplier
final supplierPurchases = await MockPurchaseRepository.getPurchases(
  supplierId: 1,
);
```

## 🔄 Integration with Real API

When ready to switch to real API:

1. Create API service classes that implement the same interface
2. Use dependency injection to switch between mock and real repositories
3. All models are already compatible with API responses

Example:
```dart
abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories({String? search, bool? isActive});
}

// Mock implementation (already created)
class MockCategoryRepository implements CategoryRepository {...}

// Real API implementation (to be created)
class ApiCategoryRepository implements CategoryRepository {
  Future<List<CategoryModel>> getCategories({String? search, bool? isActive}) async {
    final response = await http.get('/api/v1/categories');
    // Parse and return
  }
}
```

## 📚 Documentation

Full documentation available at:
- `lib/core/data/mock_data_documentation.md` - Comprehensive guide

## ✨ Best Practices Applied

1. **SOLID Principles**
   - Single Responsibility: Each repository handles one module
   - Open/Closed: Easy to extend with new filters
   - Dependency Inversion: Ready for interface-based implementation

2. **DRY (Don't Repeat Yourself)**
   - Consistent patterns across all modules
   - Reusable helper classes (ProductInfo, CreatorInfo, etc.)

3. **KISS (Keep It Simple, Stupid)**
   - Clear, readable code
   - Simple async/await patterns
   - Straightforward data structures

4. **Maintainability**
   - Well-documented code
   - Consistent naming conventions
   - Clear separation of concerns

## 🚀 Next Steps

1. **Use in UI Development**
   - Replace hardcoded data with mock repository calls
   - Test all features without backend dependency

2. **Create API Service Layer**
   - Implement real API repositories
   - Use dependency injection to switch between mock and real

3. **Add State Management**
   - Integrate with Provider/Riverpod/Bloc
   - Use repositories in state management layer

4. **Testing**
   - Unit tests for models
   - Integration tests with mock repositories

## 📝 Notes

- All mock data is static and in-memory
- No persistence layer (can be added if needed)
- Pagination not implemented (can be added if needed)
- Error simulation not included (can be added if needed)

---

**Created**: Based on Laravel API structure from `routes/api.php` and API Resources
**Last Updated**: All modules completed and ready for use

