import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/checkout/data/models/checkout_details_model.dart';

class CheckoutDetailsDataSource {
  static Future<Either<Failure, CheckoutDetailsModel>> getCheckoutDetails() async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.checkoutDetails,
      );
      log('response checkout: ${response.data}');
      return Right(CheckoutDetailsModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
