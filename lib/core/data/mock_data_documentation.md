# Mock Data Layer Documentation

This document describes the mock data layer structure for the Flutter app, which provides sample data matching the Laravel backend API responses.

## Overview

The mock data layer is organized by feature/module, with each module containing:
- **Models**: Data classes matching the API response structure
- **Mock Repositories**: Classes providing sample data for development and testing

## Architecture

### Structure

```
lib/features/
├── auth/
│   ├── models/
│   │   └── user_model.dart
│   └── data/
│       └── mock_auth_repository.dart
├── categories/
│   ├── models/
│   │   └── category_model.dart
│   └── data/
│       └── mock_category_repository.dart
├── suppliers/
│   ├── models/
│   │   └── supplier_model.dart
│   └── data/
│       └── mock_supplier_repository.dart
├── inventory/
│   ├── models/
│   │   ├── product_model.dart (existing UI model)
│   │   └── product_api_model.dart (API-compatible model)
│   └── data/
│       └── mock_product_repository.dart
├── stock_movements/
│   ├── models/
│   │   └── stock_movement_model.dart
│   └── data/
│       └── mock_stock_movement_repository.dart
├── purchases/
│   ├── models/
│   │   └── purchase_model.dart
│   └── data/
│       └── mock_purchase_repository.dart
├── sales/
│   ├── models/
│   │   └── sale_model.dart
│   └── data/
│       └── mock_sale_repository.dart
├── expense_categories/
│   ├── models/
│   │   └── expense_category_model.dart
│   └── data/
│       └── mock_expense_category_repository.dart
└── expenses/
    ├── models/
    │   └── expense_model.dart
    └── data/
        └── mock_expense_repository.dart
```

## Usage

### Basic Usage

Each mock repository provides static methods that simulate API calls:

```dart
// Get all categories
final categories = await MockCategoryRepository.getCategories();

// Get categories with filters
final filteredCategories = await MockCategoryRepository.getCategories(
  search: 'electronics',
  isActive: true,
);

// Get single category by ID
final category = await MockCategoryRepository.getCategoryById(1);
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

// Get user permissions
final permissions = await MockAuthRepository.getUserPermissions();

// Check specific permission
final hasPermission = await MockAuthRepository.checkPermission('view users');
```

### Products

```dart
// Get all products
final products = await MockProductRepository.getProducts();

// Get products with filters
final filteredProducts = await MockProductRepository.getProducts(
  search: 'laptop',
  categoryId: 1,
  isActive: true,
);

// Get single product by ID
final product = await MockProductRepository.getProductById(1);
```

## Data Models

All models follow these principles:

1. **JSON Serialization**: Models include `fromJson()` and `toJson()` methods
2. **Type Safety**: Models use proper Dart types matching API responses
3. **Null Safety**: Optional fields are properly nullable
4. **Immutability**: Models use `final` fields and `copyWith()` methods

### Model Structure Example

```dart
class CategoryModel {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({...});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
  CategoryModel copyWith({...}) {...}
}
```

## Mock Data Characteristics

### Realistic Data
- Mock data includes realistic values and relationships
- Dates are relative to current time (e.g., `DateTime.now().subtract(...)`)
- Relationships between entities are maintained (e.g., purchase items reference products)

### Network Simulation
- All mock repository methods include simulated network delays
- Delays vary by operation type (300ms for single items, 500ms for lists, 800ms+ for auth)

### Filtering Support
- Mock repositories support the same filters as the API
- Search functionality matches API behavior
- Filter combinations work correctly

## API Compatibility

All mock data structures match the Laravel API response format:

### Response Format
- Single resources: Direct object
- Collections: Array of objects
- Pagination: Not implemented in mocks (can be added if needed)

### Field Names
- Snake_case field names match API (e.g., `created_at`, `is_active`)
- Models convert to camelCase for Dart conventions

### Data Types
- Numbers: `int` for IDs and quantities, `double` for prices
- Strings: All text fields
- Booleans: Status flags
- Dates: ISO8601 strings converted to `DateTime`

## Integration with Real API

When ready to integrate with the real API:

1. **Create API Service Layer**
   ```dart
   class ApiCategoryRepository {
     static Future<List<CategoryModel>> getCategories() async {
       final response = await http.get('/api/v1/categories');
       final data = json.decode(response.body)['data'];
       return data.map((json) => CategoryModel.fromJson(json)).toList();
     }
   }
   ```

2. **Use Dependency Injection**
   ```dart
   abstract class CategoryRepository {
     Future<List<CategoryModel>> getCategories();
   }
   
   class MockCategoryRepository implements CategoryRepository {...}
   class ApiCategoryRepository implements CategoryRepository {...}
   ```

3. **Switch Between Mock and Real**
   ```dart
   final repository = useMockData 
     ? MockCategoryRepository()
     : ApiCategoryRepository();
   ```

## Available Modules

### 1. Authentication (`auth`)
- User model with roles and permissions
- Login, register, logout
- Permission checking

### 2. Categories (`categories`)
- Category CRUD operations
- Active/inactive filtering
- Search by name/description

### 3. Suppliers (`suppliers`)
- Supplier CRUD operations
- Search by name, contact, email, address

### 4. Products (`inventory`)
- Product CRUD operations
- Category filtering
- Active status filtering
- Search by name/SKU

### 5. Stock Movements (`stock_movements`)
- Stock movement history
- Filter by product, type (in/out), reason
- Includes product and creator information

### 6. Purchases (`purchases`)
- Purchase orders with items
- Linked expenses
- Supplier information
- Filter by supplier

### 7. Sales (`sales`)
- Sales transactions with items
- Customer information
- Product details in items

### 8. Expense Categories (`expense_categories`)
- Expense category CRUD
- Active status filtering
- Common categories (Transport, Rent, etc.)

### 9. Expenses (`expenses`)
- Expense entries
- Can be linked to purchases or standalone
- Date range filtering
- Category filtering

## Best Practices

1. **Use Mock Data for Development**
   - Mock repositories are perfect for UI development
   - Test all features without backend dependency

2. **Maintain API Compatibility**
   - Keep mock data structures matching API responses
   - Update mocks when API changes

3. **Realistic Relationships**
   - Maintain referential integrity in mock data
   - Product IDs in purchases match actual products

4. **Error Simulation**
   - Can extend mocks to simulate errors
   - Network failures, validation errors, etc.

## Future Enhancements

- [ ] Add pagination support to mock repositories
- [ ] Add error simulation capabilities
- [ ] Add data persistence (local storage)
- [ ] Add data generation utilities
- [ ] Add unit tests for mock repositories

