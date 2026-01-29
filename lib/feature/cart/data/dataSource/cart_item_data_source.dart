import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/cart/data/models/cart_item_model.dart';

import '../../../../core/network/local/cache.dart';
import '../../../../core/utils/constants.dart';

class CartItemDataSource {
  static Future<Either<Failure, CartModel>> getCartItems() async {
    try {
      final response = await DioHelper.postData(endPoint: EndPoints.cartItems, query: {
        'theme_id': 'grocery',
        'customer_id': loginCacheValue?.data?.id,
      },data: {});
      if (response.data['status'] == 1) {
        return Right(CartModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      log('error in getCartItems $error');
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
