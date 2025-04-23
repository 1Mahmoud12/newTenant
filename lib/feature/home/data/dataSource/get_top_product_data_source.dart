import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';

class GetTopProductDataSource {
  static Future<Either<Failure, ProductModel>> getTopProduct({int? subCategoryId, String? searchProductByName}) async {
    try {
      final response = await DioHelper.getData(
        query: {
          if (subCategoryId != null) 'filter[categories][]': subCategoryId,
          if (searchProductByName != null) 'products?filter[name]=': searchProductByName,
        },
        url: EndPoints.getTopProduct,
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
