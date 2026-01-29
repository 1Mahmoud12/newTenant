import 'package:dobzz_seller/feature/allProducts/data/dataSource/all_products_data_source.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'all_products_state.dart';

class AllProductsCubit extends Cubit<AllProductsState> {
  AllProductsCubit() : super(AllProductsInitial());

  Future<void> fetchProducts() async {
    emit(AllProductsLoading());

    final result = await AllProductsDataSource.getAllProducts();

    result.fold(
      (failure) => emit(AllProductsError(failure.errMessage)),
      (productModel) {
        final products = productModel.data ?? [];

        emit(AllProductsSuccess(
          allProducts: products,
          filteredProducts: products,
          selectedCategoryId: null,
        ));
      },
    );
  }

  void filterByCategory(int? categoryId) {
    if (state is AllProductsSuccess) {
      final currentState = state as AllProductsSuccess;

      final filteredProducts =
          categoryId == null ? currentState.allProducts : currentState.allProducts.where((product) => product.categoryId == categoryId).toList();

      emit(currentState.copyWith(
        filteredProducts: filteredProducts,
        selectedCategoryId: categoryId,
        clearSelection: categoryId == null,
      ));
    }
  }
}
