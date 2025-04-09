import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mamlaka/core/network/dio_helper.dart';
import 'package:mamlaka/core/network/end_points.dart';
import 'package:mamlaka/core/network/errors/failures.dart';
import 'package:mamlaka/core/network/local/cache.dart';
import 'package:mamlaka/feature/auth/data/models/country_code_model.dart';
import 'package:mamlaka/feature/auth/data/models/login_params.dart';
import 'package:mamlaka/feature/auth/data/models/register_model.dart';
import 'package:mamlaka/feature/auth/data/models/reset_password_params.dart';
import 'package:mamlaka/feature/auth/data/models/sign_up_params.dart';
import 'package:mamlaka/feature/auth/data/models/verify_code_model.dart';

abstract class AuthDataSource {
  Future<Either<Failure, CountryCodeModel>> getCountryCode();

  Future<Either<Failure, String>> forgetPassword(BuildContext context, String phoneNumber, int countryCodeId);

  Future<Either<Failure, String>> resendCode(BuildContext context, String phoneNumber, int countryCodeId);

  Future<Either<Failure, String>> resetPasswordPassword(BuildContext context, ResetPasswordParams resetPasswordParams);

  Future<Either<Failure, String>> postSignUp(BuildContext context, SignUpParams signUpParams);

  Future<Either<Failure, RegisterModel>> postLogin(BuildContext context, LoginParams loginParams);

  Future<Either<Failure, RegisterModel>> verifyCode(BuildContext context, VerifyCodeModel verifyCodeModel);
}

class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<Either<Failure, CountryCodeModel>> getCountryCode() async {
    try {
      const endpoint = EndPoints.countryCodes;
      final response = await DioHelper.getData(
        url: endpoint,
      );
      log('object response.dataSource ${response.data.runtimeType}');
      return right(CountryCodeModel.fromJson(response.data));
    } catch (error) {
      log(error.toString());

      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      }
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> postSignUp(BuildContext context, SignUpParams signUpParams) async {
    try {
      const endpoint = EndPoints.register;
      final response = await DioHelper.postData(
        endPoint: endpoint,
        data: signUpParams.toMap(),
        context: context,
      );
      log('object response.dataSource ${response.data.runtimeType}');
      return right('');
    } catch (error) {
      log(error.toString());

      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      }
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, RegisterModel>> verifyCode(BuildContext context, VerifyCodeModel verifyCodeModel) async {
    try {
      const endpoint = EndPoints.validateOTP;
      final response = await DioHelper.postData(
        endPoint: endpoint,
        data: verifyCodeModel.toJson(),
        context: context,
      );
      log('object response.dataSource ${response.data.runtimeType}');
      return right(RegisterModel.fromJson(response.data));
    } catch (error) {
      log(error.toString());

      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      }
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, RegisterModel>> postLogin(BuildContext context, LoginParams loginParams) async {
    try {
      const endpoint = EndPoints.login;
      final response = await DioHelper.postData(
        endPoint: endpoint,
        data: loginParams.toMap(),
        context: context,
        //  formDataIsEnabled: true,
      );
      log('object response.dataSource ${response.data.runtimeType}');
      return right(RegisterModel.fromJson({'Data': response.data}));
    } catch (error) {
      log(error.toString());

      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      }
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgetPassword(BuildContext context, String phoneNumber, int countryCodeId) async {
    try {
      final String endpoint = '${EndPoints.forgetPassword}?phone=$phoneNumber&CountryCodeId=$countryCodeId';
      final response = await DioHelper.getData(
        url: endpoint,
        context: context,
      );
      idUserValue = response.data['Data']['UserId'];
      userCache?.put(idUserKey, response.data['Data']['UserId']);
      return right('Success');
    } catch (error) {
      log(error.toString());

      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      }
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resendCode(BuildContext context, String phoneNumber, int countryCodeId) async {
    try {
      final String endpoint = '${EndPoints.resendOtp}?PhoneNumber=$phoneNumber&CountryCodeId=$countryCodeId';
      await DioHelper.postData(
        endPoint: endpoint,
        data: {},
        context: context,
      );
      //  idUserValue = response.dataSource['Data']['UserId'];
      //  userCache?.put(idUserKey, response.dataSource['Data']['UserId']);
      return right('Success');
    } catch (error) {
      log(error.toString());

      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      }
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resetPasswordPassword(BuildContext context, ResetPasswordParams resetPasswordParams) async {
    try {
      const endpoint = EndPoints.resetPassword;
      final response = await DioHelper.postData(
        endPoint: endpoint,
        data: resetPasswordParams.toMap(),
        context: context,
        //  formDataIsEnabled: true,
      );
      log('object response.dataSource ${response.data.runtimeType}');
      return right('');
    } catch (error) {
      log(error.toString());

      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      }
      return left(ServerFailure(error.toString()));
    }
  }
}
