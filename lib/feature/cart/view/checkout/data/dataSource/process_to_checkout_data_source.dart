import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/main.dart';

abstract class ProcessToCheckoutDataSource {
  Future<Either<Failure, int>> processToCheckout({
    required String addressId,
  });
}

class ProcessToCheckoutDataSourceImpl implements ProcessToCheckoutDataSource {
  @override
  Future<Either<Failure, int>> processToCheckout({
    required String addressId,
  }) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.processToCheckout,
        data: {
          'address_id': addressId,
          'payment_method': 'cash',
        },
      );
      final int idOrder = response.data['data']['order']['id'];
      logger.e(response.data['data']['order']['id']);
      return Right(idOrder);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
