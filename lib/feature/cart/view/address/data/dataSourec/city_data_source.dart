import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/cart/view/address/data/models/city_model.dart';

class CityDataSource {
  static Future<Either<Failure, CityModel>> getCities({required int stateId}) async {
    try {
      final response = await DioHelper.getData(url: '${EndPoints.cities}?filter[state_id]=$stateId');
      log('response1234===>${response.data}');
      return Right(CityModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
