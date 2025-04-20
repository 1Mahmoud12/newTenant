import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';

class AddToCartDataSource {
  static Future<Either<Failure, void>> addToCart({required int productId, required int quantity}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.cartItems,
        data: {
          'product_id': productId,
          'quantity': quantity,
        },
      );
      log('Top Product Response: ${response.data['data']}');
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
