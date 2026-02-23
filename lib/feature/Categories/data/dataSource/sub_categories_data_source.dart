import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rova_star/core/network/dio_helper.dart';
import 'package:rova_star/core/network/end_points.dart';
import 'package:rova_star/core/network/errors/failures.dart';
import 'package:rova_star/feature/Categories/data/models/sub_categories_models.dart';

class SubCategoriesDataSource {
  static Future<Either<Failure, SubCategoryModel>> getSubCategories({required int categoryId}) async {
    try {
      final response = await DioHelper.getData(url: '${EndPoints.subCategories}$categoryId');
      log('Response: ${response.data['data']}');
      return Right(SubCategoryModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
