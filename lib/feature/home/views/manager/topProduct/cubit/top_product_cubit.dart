import 'dart:developer';

import 'package:dobzz_seller/core/services/cache_service.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/get_top_product_data_source.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_product_state.dart';

enum ProductsFeed { top, bestSeller, newArrival }

class TopProductCubit extends Cubit<TopProductState> {
  TopProductCubit() : super(TopProductInitial());

  List<Product> products = [];

  static TopProductCubit of(BuildContext context) => BlocProvider.of<TopProductCubit>(context);

  Future<bool> loadFromCache(ProductsFeed feed) async {
    final key = switch (feed) {
      ProductsFeed.top => HomeCacheKeys.topProducts,
      ProductsFeed.bestSeller => HomeCacheKeys.bestSeller,
      ProductsFeed.newArrival => HomeCacheKeys.newArrivals,
    };
    final cached = await CacheService.getJson(key: key);
    if (cached == null) return false;
    final model = ProductModel.fromJson(cached);
    products = model.data ?? [];
    switch (feed) {
      case ProductsFeed.top:
        ConstantsModels.topProductModel = model;
        break;
      case ProductsFeed.bestSeller:
        ConstantsModels.bestSellerModel = model;
        break;
      case ProductsFeed.newArrival:
        ConstantsModels.newArrivalsModel = model;
        break;
    }
    if (isClosed) return true;
    emit(TopProductSuccess());
    return true;
  }

  Future<void> getTopProduct({required BuildContext context, int? subCategoryId, String? searchProductByName}) async {
    if (isClosed) return;
    emit(TopProductLoading());
    await GetTopProductDataSource.getTopProduct(subCategoryId: subCategoryId, searchProductByName: searchProductByName).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;
          emit(TopProductError(e: l.errMessage));
        }, (r) async {
          products.addAll(r.data ?? []);
          if (subCategoryId != null) {
            ConstantsModels.productsModel = r;
          } else if (searchProductByName != null) {
            ConstantsModels.searchProductsModel = r;
          } else {
            ConstantsModels.topProductModel = r;
          }
          log('Top Product: ${ConstantsModels.topProductModel?.data?.length}');
          if (isClosed) return;
          emit(TopProductSuccess());
        });
      },
    );
  }

  bool bestsellerHasProducts = true;
  bool topHasProducts = true;
  bool newArrivalHasProducts = true;
  int currentPage = 1;
  int? lastPage;
  bool isLoadingMore = false;
  ProductsFeed? currentFeed;
  int? currentSubCategoryId;

  Future<void> getProductsByFeed({
    required BuildContext context,
    required ProductsFeed feed,
    int? subCategoryId,
    bool isRefresh = false,
  }) async {
    if (isClosed) return;

    // Reset pagination logic
    if (!isLoadingMore || isRefresh) {
      currentPage = 1;
      lastPage = null;
      currentFeed = feed;
      currentSubCategoryId = subCategoryId;
    }

    if (currentPage == 1) {
      // Try cache first only for initial load
      final servedFromCache = await loadFromCache(feed);
      if (!servedFromCache) {
        emit(TopProductLoading());
      }
    }

    await GetTopProductDataSource.getProductsByFeed(
      feed: feed,
      subCategoryId: subCategoryId,
      page: currentPage,
    ).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;
          isLoadingMore = false;
          emit(TopProductError(e: l.errMessage));
        }, (r) async {
          if (currentPage == 1) {
            products = r.data ?? [];
          } else {
            products.addAll(r.data ?? []);
          }

          // Update pagination info
          currentPage = r.currentPage ?? currentPage;
          lastPage = r.lastPage;

          isLoadingMore = false;

          switch (feed) {
            case ProductsFeed.top:
              topHasProducts = products.isNotEmpty;
              ConstantsModels.topProductModel = r;
              break;
            case ProductsFeed.bestSeller:
              bestsellerHasProducts = products.isNotEmpty;
              ConstantsModels.bestSellerModel = r;
              break;
            case ProductsFeed.newArrival:
              newArrivalHasProducts = products.isNotEmpty;
              ConstantsModels.newArrivalsModel = r;
              break;
          }
          if (isClosed) return;
          emit(TopProductSuccess());
        });
      },
    );
  }

  Future<void> loadMoreProducts(BuildContext context) async {
    if (isLoadingMore || (lastPage != null && currentPage >= lastPage!)) return;

    isLoadingMore = true;
    currentPage++;

    // Safety check - if feed not set, default to something or return
    if (currentFeed == null) {
      isLoadingMore = false;
      return;
    }

    await getProductsByFeed(
      context: context,
      feed: currentFeed!,
      subCategoryId: currentSubCategoryId,
    );
  }
}
