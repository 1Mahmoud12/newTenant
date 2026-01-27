import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/address/data/models/address_model.dart' ;

import '../../../../core/utils/constants.dart'hide AddressModel;

class AddressDataSource {
  static Future<Either<Failure, AddressModel>> getAddress() async {
    try {
      final response = await DioHelper.postData(endPoint: EndPoints.address,data: {
        "theme_id": "grocery",
        "customer_id": Constants.customerId,

      });
      // logger.d('response address: ${response.data['data']}');
      return Right(AddressModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, String>> deleteAddress({required int addressId}) async {
    try {
      final response = await DioHelper.deleteData(endPoint: '${EndPoints.address}/$addressId', data: {});
      log('Response address: ${response.data['data']}');
      return const Right('address delete successfully');
    } catch (error) {
      log('Dio error message: $error');

      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, void>> addAddress({required Map<String, dynamic> data}) async {
    try {
      final response = await DioHelper.postData(endPoint: EndPoints.address, data: data);
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, void>> updateAddress({required Map<String, dynamic> data, required int addressId}) async {
    try {
      final response = await DioHelper.postData(endPoint: '${EndPoints.address}/$addressId', data: data);
      log('Response: ${response.data['data']}');
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
