import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/feature/favorites/data/model/wish_list_model.dart';

import '../../../../core/network/local/cache.dart';

class WishListDataSource {
  // Get all products in wishlist - POST API with customer_id parameter
  static Future<Either<Failure, WishListModel>> getWishList() async {
    try {
      final customerId = loginCacheValue?.data?.id;
      final response = await DioHelper.postData(
        endPoint: 'wishlist-list',
        query: {if (customerId != null) 'customer_id': customerId},
        data: {},
      );
      return Right(WishListModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  // Add or remove product from wishlist - POST API with parameters
  // wishlist_type can be 'add' or 'remove'
  static Future<Either<Failure, dynamic>> toggleWishList({
    required int productId,
    required String wishlistType, // 'add' or 'remove'
  }) async {
    try {
      final customerId = Constants.customerId ?? '2';
      final response = await DioHelper.postData(
        endPoint: 'wishlist',
        query: {
          'customer_id': customerId,
          'product_id': productId.toString(),
          'wishlist_type': wishlistType,
        },
        data: {},
      );
      return Right(response.data);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
