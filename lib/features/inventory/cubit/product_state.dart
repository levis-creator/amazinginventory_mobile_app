import 'package:equatable/equatable.dart';
import '../models/product_api_model.dart';

/// Base class for product states.
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial product state (unknown).
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// Product loading state (fetching products).
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// Product loaded state with list of products.
class ProductLoaded extends ProductState {
  final List<ProductApiModel> products;
  final Map<String, dynamic>? paginationMeta;
  final Map<String, dynamic>? paginationLinks;

  const ProductLoaded({
    required this.products,
    this.paginationMeta,
    this.paginationLinks,
  });

  @override
  List<Object?> get props => [products, paginationMeta, paginationLinks];

  /// Creates a copy of this state with updated values.
  ProductLoaded copyWith({
    List<ProductApiModel>? products,
    Map<String, dynamic>? paginationMeta,
    Map<String, dynamic>? paginationLinks,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      paginationMeta: paginationMeta ?? this.paginationMeta,
      paginationLinks: paginationLinks ?? this.paginationLinks,
    );
  }
}

/// Product error state.
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
