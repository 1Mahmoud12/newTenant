import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/core/services/cache_service.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';
import 'package:dobzz_seller/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';

class GetTopProductDataSource {
  static Future<Either<Failure, ProductModel>> getTopProduct({
    int? subCategoryId,
    String? searchProductByName,
  }) async {
    try {
      final response = await DioHelper.getData(
        query: {
          if (subCategoryId != null) 'filter[categories][]': subCategoryId,
          if (searchProductByName != null) 'filter[name]': searchProductByName,
        },
        url: EndPoints.search,
      );
      // log('Top Product Response: ${response.data['data']}');
      final model = ProductModel.fromJson(response.data);
      // Cache top products search result (optional: only when no filters)
      if (subCategoryId == null && (searchProductByName == null || searchProductByName.isEmpty)) {
        await CacheService.setJson(
          key: HomeCacheKeys.topProducts,
          value: model.toJson(),
        );
      }
      return Right(model);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, ProductModel>> getProductsByFeed({
    required ProductsFeed feed,
    int? subCategoryId,
  }) async {
    try {
      final String url = switch (feed) {
        ProductsFeed.top => EndPoints.getTopProduct,
        ProductsFeed.bestSeller => EndPoints.bestSeller,
        ProductsFeed.newArrival => EndPoints.newArrivals,
      };

      final response = await DioHelper.getData(
        query: {
          if (subCategoryId != null) 'filter[categories][]': subCategoryId,
        },
        url: url,
      );
      final model = ProductModel.fromJson(response.data);
      // Cache by feed
      switch (feed) {
        case ProductsFeed.top:
          await CacheService.setJson(
            key: HomeCacheKeys.topProducts,
            value: model.toJson(),
          );
          break;
        case ProductsFeed.bestSeller:
          await CacheService.setJson(
            key: HomeCacheKeys.bestSeller,
            value: model.toJson(),
          );
          break;
        case ProductsFeed.newArrival:
          await CacheService.setJson(
            key: HomeCacheKeys.newArrivals,
            value: model.toJson(),
          );
          break;
      }
      return Right(model);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
