import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';

class SearchDataSource {
  static Future<Either<Failure, ProductModel>> searchProducts({
    required String name,
    int page = 1,
  }) async {
    try {
      final response = await DioHelper.postData(
        query: {
          'theme_id': 'grocery',
          'type': 'product_filter',
          'name': name,
          'page': page,
        },
        endPoint: EndPoints.search,
        data: {}, // POST request with empty body logic
      );

      final model = ProductModel.fromJson(response.data);
      return Right(model);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
