import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';

class AddToCartDataSource {
  static Future<Either<Failure, void>> addToCart({required String sku, required int quantity, String? sizeCode}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.cartItems,
        data: {
          'sku_code': sku,
          'quantity': quantity,
          if (sizeCode != null) 'size': sizeCode,
        },
      );
      log('add to cart Response: ${response.data}');
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, void>> updateCartItem({required int cartItemId, required int quantity}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: '${EndPoints.cartItems}/$cartItemId',
        data: {
          'quantity': quantity,
          '_method': 'put',
        },
      );
      log('add to cart Response: ${response.data}');
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
