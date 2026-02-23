import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rova_star/core/network/dio_helper.dart';
import 'package:rova_star/core/network/end_points.dart';
import 'package:rova_star/core/network/errors/failures.dart';

class AddToWishListDataSource {
  static Future<Either<Failure, void>> addToWishList({required String skuCode}) async {
    try {
      await DioHelper.postData(
        endPoint: EndPoints.wishlist,
        data: {
          'sku_code': skuCode,
        },
      );
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
