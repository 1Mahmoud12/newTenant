import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rova_star/core/network/dio_helper.dart';
import 'package:rova_star/core/network/end_points.dart';
import 'package:rova_star/core/network/errors/failures.dart';

class RemoveFrommWishListDataSource {
  static Future<Either<Failure, void>> removeFromWishList({required int productId}) async {
    try {
      await DioHelper.deleteData(
        endPoint: '${EndPoints.wishlist}/$productId',
        data: {},
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
