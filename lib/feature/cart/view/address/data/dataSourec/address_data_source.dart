import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/cart/view/address/data/models/address_model.dart';

class AddressDataSource {
  static Future<Either<Failure, AddressModel>> getAddress() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.address);
      log('Response: ${response.data['data']}');
      return Right(AddressModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
