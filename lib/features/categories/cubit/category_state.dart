import 'package:equatable/equatable.dart';
import '../models/category_model.dart';

/// Base class for category states.
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];

  /// Pattern matching method for handling different states
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(List<CategoryModel> categories, Map<String, dynamic>? paginationMeta, Map<String, dynamic>? paginationLinks) loaded,
    required T Function(String message) error,
  }) {
    if (this is CategoryInitial) {
      return initial();
    } else if (this is CategoryLoading) {
      return loading();
    } else if (this is CategoryLoaded) {
      final state = this as CategoryLoaded;
      return loaded(state.categories, state.paginationMeta, state.paginationLinks);
    } else if (this is CategoryError) {
      final state = this as CategoryError;
      return error(state.message);
    }
    throw Exception('Unknown state: $this');
  }
}

/// Initial category state (unknown).
class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

/// Category loading state (fetching categories).
class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

/// Category loaded state with list of categories.
class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  final Map<String, dynamic>? paginationMeta;
  final Map<String, dynamic>? paginationLinks;

  const CategoryLoaded({
    required this.categories,
    this.paginationMeta,
    this.paginationLinks,
  });

  @override
  List<Object?> get props => [categories, paginationMeta, paginationLinks];

  /// Creates a copy of this state with updated values.
  CategoryLoaded copyWith({
    List<CategoryModel>? categories,
    Map<String, dynamic>? paginationMeta,
    Map<String, dynamic>? paginationLinks,
  }) {
    return CategoryLoaded(
      categories: categories ?? this.categories,
      paginationMeta: paginationMeta ?? this.paginationMeta,
      paginationLinks: paginationLinks ?? this.paginationLinks,
    );
  }
}

/// Category error state.
class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

