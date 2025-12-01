# Libraries Guide

This document explains the additional libraries added to improve efficiency and maintainability.

## Added Libraries

### 1. **Dio** (`dio: ^5.4.0`)
A powerful HTTP client for Dart/Flutter with better features than the standard `http` package.

**Benefits:**
- Automatic JSON parsing
- Request/Response interceptors
- Better error handling
- Request cancellation
- Timeout configuration
- File upload support

**Usage:**
The `ApiService` now uses Dio internally. No changes needed in your code - it's a drop-in replacement.

### 2. **JSON Annotation & Serialization** (`json_annotation`, `json_serializable`)
Automatic JSON serialization/deserialization code generation.

**Benefits:**
- Reduces boilerplate code
- Type-safe JSON conversion
- Automatic null handling
- Compile-time error checking

**Usage Example:**
```dart
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final int id;
  final String name;
  final double price;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
  });

  // Auto-generated fromJson
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  // Auto-generated toJson
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
```

**To generate code:**
```bash
flutter pub run build_runner build
# Or watch mode for auto-regeneration:
flutter pub run build_runner watch
```

### 3. **Equatable** (`equatable: ^2.0.5`)
Simplifies value equality comparisons for models.

**Benefits:**
- No need to override `==` and `hashCode`
- Cleaner code
- Better for state management

**Usage Example:**
```dart
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final double price;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object> get props => [id, name, price];
}

// Now you can compare:
final product1 = ProductModel(id: 1, name: 'Product', price: 10.0);
final product2 = ProductModel(id: 1, name: 'Product', price: 10.0);
print(product1 == product2); // true
```

### 4. **Build Runner** (`build_runner: ^2.4.7`)
Code generation tool for Dart.

**Usage:**
```bash
# Generate code once
flutter pub run build_runner build

# Watch mode (auto-regenerates on file changes)
flutter pub run build_runner watch

# Clean and rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

## JSON Utilities

A utility class `JsonUtils` has been created in `lib/core/utils/json_utils.dart` with helper methods for:
- Safe type parsing (`safeParse`, `safeParseDouble`, `safeParseInt`, etc.)
- Safe DateTime parsing
- Safe list parsing
- JSON map merging
- Null-safe JSON conversion

**Usage:**
```dart
import 'package:amazinginventory/core/utils/json_utils.dart';

// Safe parsing
final price = JsonUtils.safeParseDouble(json['price']); // Returns null if invalid
final id = JsonUtils.safeParseInt(json['id']);
final isActive = JsonUtils.safeParseBool(json['is_active']);
final date = JsonUtils.safeParseDateTime(json['created_at']);

// Remove nulls from JSON
final cleanJson = JsonUtils.toJsonSafe(data, removeNulls: true);
```

## Migration Guide

### Migrating Models to Use json_serializable

1. Add annotations to your model:
```dart
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  // ... fields
}
```

2. Add part directive at the top:
```dart
part 'product_model.g.dart';
```

3. Replace manual `fromJson`/`toJson` with generated code:
```dart
factory ProductModel.fromJson(Map<String, dynamic> json) =>
    _$ProductModelFromJson(json);

Map<String, dynamic> toJson() => _$ProductModelToJson(this);
```

4. Run build_runner:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Best Practices

1. **Use Dio for all HTTP requests** - Already integrated in `ApiService`
2. **Use json_serializable for new models** - Reduces boilerplate and errors
3. **Use Equatable for models** - Simplifies comparisons and state management
4. **Use JsonUtils for manual parsing** - When you can't use code generation
5. **Run build_runner in watch mode during development** - Auto-regenerates code on changes

## Next Steps

1. Run `flutter pub get` to install the new dependencies
2. Consider migrating existing models to use `json_serializable`
3. Use `Equatable` for models that need value equality
4. Leverage `JsonUtils` for safe JSON parsing

