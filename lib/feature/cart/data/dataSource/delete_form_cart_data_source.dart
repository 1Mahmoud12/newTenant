import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rova_star/core/network/dio_helper.dart';
import 'package:rova_star/core/network/end_points.dart';
import 'package:rova_star/core/network/errors/failures.dart';

class DeleteFromCart {
  static Future<Either<Failure, void>> deleteFromCart({required int itemId}) async {
    try {
      final response = await DioHelper.deleteData(endPoint: '${EndPoints.cartItems}/$itemId', data: {});
      log('Cart Response: ${response.data}');
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
