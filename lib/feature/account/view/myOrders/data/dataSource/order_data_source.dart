import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/data/models/order_model.dart';

class OrderDataSource {
  static Future<Either<Failure, OrderModel>> getOrders() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.order);
      log('Cart Response: ${response.data['data']}');
      return Right(OrderModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
