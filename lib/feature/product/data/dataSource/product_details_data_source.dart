import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rova_star/core/network/dio_helper.dart';
import 'package:rova_star/core/network/end_points.dart';
import 'package:rova_star/core/network/errors/failures.dart';
import 'package:rova_star/feature/product/data/model/product_details_model.dart';
import 'package:rova_star/main.dart';

class ProductDetailsDataSource {
  static Future<Either<Failure, ProductDetailsModel>> getProductDetails({required int productId}) async {
    try {
      final response = await DioHelper.getData(url: '${EndPoints.getProductDetails}/$productId');
      logger.d('Response: ${response.data['data']}');
      return Right(ProductDetailsModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
