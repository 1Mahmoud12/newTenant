import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/search_data_source.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  List<Product> products = [];
  int currentPage = 1;
  int? lastPage;
  bool isLoadingMore = false;
  String? currentQuery;

  static SearchCubit of(BuildContext context) => BlocProvider.of<SearchCubit>(context);

  Future<void> searchProducts({
    required String name,
    bool isRefresh = false,
  }) async {
    if (isClosed) return;

    if (name.isEmpty) {
      products.clear();
      ConstantsModels.searchProductsModel = null;
      emit(SearchInitial());
      return;
    }

    if (isRefresh || currentQuery != name) {
      currentPage = 1;
      lastPage = null;
      products.clear();
      currentQuery = name;
      emit(SearchLoading());
    }

    await SearchDataSource.searchProducts(name: name, page: currentPage).then(
      (value) {
        value.fold((l) {
          if (isClosed) return;
          isLoadingMore = false;
          emit(SearchError(e: l.errMessage));
        }, (r) {
          if (isClosed) return;

          if (currentPage == 1) {
            products = r.data ?? [];
          } else {
            products.addAll(r.data ?? []);
          }

          currentPage = r.currentPage ?? currentPage;
          lastPage = r.lastPage;
          isLoadingMore = false;

          ConstantsModels.searchProductsModel = r;
          ConstantsModels.searchProductsModel?.data = products; // Sync local list

          emit(SearchSuccess());
        });
      },
    );
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore || (lastPage != null && currentPage >= lastPage!) || currentQuery == null) return;

    isLoadingMore = true;
    currentPage++;
    // We don't emit loading state here to avoid clearing the list,
    // UI can handle spinner based on isLoadingMore or use a separate state if needed.
    // However, usually we just call searchProducts again.

    await searchProducts(name: currentQuery!); // logic inside handles appending because isRefresh is false
  }
}
