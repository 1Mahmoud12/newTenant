import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rova_star/core/network/dio_helper.dart';
import 'package:rova_star/core/network/end_points.dart';
import 'package:rova_star/core/network/errors/failures.dart';
import 'package:rova_star/main.dart';

abstract class ProcessToCheckoutDataSource {
  Future<Either<Failure, int>> processToCheckout({
    required String addressId,
    required String paymentMethod,
  });
}

class ProcessToCheckoutDataSourceImpl implements ProcessToCheckoutDataSource {
  @override
  Future<Either<Failure, int>> processToCheckout({
    required String addressId,
    required String paymentMethod,
  }) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.processToCheckout,
        data: {
          'address_id': addressId,
          'payment_method': paymentMethod,
        },
      );
      if (response.data['status'] == false) {
        return Left(ServerFailure(response.data['message']));
      }
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
