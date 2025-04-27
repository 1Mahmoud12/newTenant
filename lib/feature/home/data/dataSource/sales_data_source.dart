import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/home/data/models/sales_model.dart';

class SalesDataSource {
  static Future<Either<Failure, SalesBannerModel>> getSalesBanner() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.banner);
      log('respons=======>${response.data}');

      return Right(SalesBannerModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
