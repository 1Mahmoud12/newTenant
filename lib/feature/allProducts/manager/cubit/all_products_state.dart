part of 'all_products_cubit.dart';

sealed class AllProductsState {}

class AllProductsInitial extends AllProductsState {}

class AllProductsLoading extends AllProductsState {}

class AllProductsSuccess extends AllProductsState {
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final int? selectedCategoryId;

  AllProductsSuccess({
    required this.allProducts,
    required this.filteredProducts,
    this.selectedCategoryId,
  });

  AllProductsSuccess copyWith({
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    int? selectedCategoryId,
    bool clearSelection = false,
  }) {
    return AllProductsSuccess(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategoryId: clearSelection ? null : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }
}

class AllProductsError extends AllProductsState {
  final String message;

  AllProductsError(this.message);
}
