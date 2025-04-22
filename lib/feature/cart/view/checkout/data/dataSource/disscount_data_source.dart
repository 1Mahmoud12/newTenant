import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/models/promo_code_model.dart';

class DisscountDataSource {
  static Future<Either<Failure, PromoCodeModel>> discount({required String discountCode}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.discount,
        data: {
          'code': discountCode,
        },
      );
      if (response.data['status'] == false) {
        return Left(ServerFailure(response.data['message']));
      }
      return Right(PromoCodeModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
