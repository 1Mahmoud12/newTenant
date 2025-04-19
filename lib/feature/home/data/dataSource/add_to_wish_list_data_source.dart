import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';

class AddToWishListDataSource {
  static Future<Either<Failure, void>> addToWishList({required int productId}) async {
    try {
      await DioHelper.postData(
        endPoint: EndPoints.wishlist,
        data: {
          'product_id': productId,
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
