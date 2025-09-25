import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/favorites/data/model/wish_list_model.dart';

class WishListDataSource {
  static Future<Either<Failure, WishListModel>> getWishList() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.addToWishList);
      return Right(WishListModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
