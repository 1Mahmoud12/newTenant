import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/models/payment_credit_model.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/models/payment_credit_params.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/models/payment_method_model.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/models/payment_stc_first_params.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/models/stc_first_model.dart';
import 'package:dobzz_seller/main.dart';

abstract class ProcessToCheckoutDataSource {
  Future<Either<Failure, int>> processToCheckout({required String addressId});

  Future<Either<Failure, PaymentMethodModel>> getPaymentMethod();

  Future<Either<Failure, PaymentCreditModel>> paymentCreditMethod({required PaymentCreditParams params});

  Future<Either<Failure, StcFirstModel>> paymentStcFirstMethod({required PaymentStcFirstParams params});

  Future<Either<Failure, String>> paymentStcSecondMethod({required String transactionUrl, required String otp});
}

class ProcessToCheckoutDataSourceImpl implements ProcessToCheckoutDataSource {
  @override
  Future<Either<Failure, int>> processToCheckout({required String addressId}) async {
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

  @override
  Future<Either<Failure, PaymentMethodModel>> getPaymentMethod() async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.getAllPaymentGetaways,
      );
      return Right(PaymentMethodModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentCreditModel>> paymentCreditMethod({required PaymentCreditParams params}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.creditCard,
        data: params.toJson(),
      );
      final result = PaymentCreditModel.fromJson(response.data);
      return Right(result);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, StcFirstModel>> paymentStcFirstMethod({required PaymentStcFirstParams params}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.stcPayFirst,
        data: params.toJson(),
      );
      final result = StcFirstModel.fromJson(response.data);
      return Right(result);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> paymentStcSecondMethod({required String transactionUrl, required String otp}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.stcPaySecond,
        data: {'transaction_url': transactionUrl, 'otp_value': otp},
      );
      return Right(response.data['payment']['status']);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
