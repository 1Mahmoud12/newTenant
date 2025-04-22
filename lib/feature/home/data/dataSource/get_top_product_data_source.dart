import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';

class GetTopProductDataSource {
  static Future<Either<Failure, ProductModel>> getTopProduct({int? subCategoryId}) async {
    try {
      final response = await DioHelper.getData(
        url: subCategoryId != null ? '${EndPoints.getTopProduct}?filter[categories][]=$subCategoryId' : EndPoints.getTopProduct,
      );
      log('Top Product Response: ${response.data['data']}');
      return Right(ProductModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
