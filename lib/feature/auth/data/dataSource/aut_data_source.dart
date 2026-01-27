import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/api_error_model.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/auth/data/models/country_code_model.dart';
import 'package:dobzz_seller/feature/auth/data/models/login_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/register_model.dart';
import 'package:dobzz_seller/feature/auth/data/models/reset_password_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/sign_up_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/verify_code_model.dart';
import 'package:flutter/cupertino.dart';

import '../models/login_response.dart';

abstract class AuthDataSource {
  Future<Either<Failure, CountryCodeModel>> getCountryCode();

  Future<Either<Failure, String>> forgetPassword(BuildContext context, {required String phone});

  Future<Either<Failure, String>> resendCode(BuildContext context,
      {required String phone, String? customerId, required bool isLogin});

  Future<Either<Failure, String>> resetPasswordPassword(
      BuildContext context, ResetPasswordParams resetPasswordParams);

  Future<Either<Failure, String>> postSignUp(BuildContext context, SignUpParams signUpParams);

  Future<Either<Failure, LoginResponse>> postLogin(BuildContext context, LoginParams loginParams);

  Future<Either<Failure, RegisterModel>> verifyCode(
      BuildContext context, VerifyCodeModel verifyCodeModel,
      {bool isForgetPassword = false});
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
        options: Options(
          validateStatus: (status) {
            // Consider all responses below 500 as "valid" responses
            // This allows us to handle error responses in our code rather than
            // having Dio throw exceptions for 4xx responses
            return status != null && status < 500;
          },
        ),
      );
      final responseModel = RegisterModel.fromJson(response.data);

      // Now check if the response indicates success or an error
      // Success case
        if (responseModel.status == 1) {

          return right('');
        } else {
          return left(ServerFailure(responseModel.message ?? 'error in sign up'));
        }
    } catch (error) {
      log(error.toString());
      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      }
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, RegisterModel>> verifyCode(
      BuildContext context, VerifyCodeModel verifyCodeModel,
      {bool isForgetPassword = false}) async {
    try {
      final String endpoint =
          isForgetPassword ? EndPoints.verifyForgetPasswordOtp : EndPoints.validateOTP;
      final response = await DioHelper.postData(
        endPoint: endpoint,
        data: verifyCodeModel.toJson(),
        context: context,
      );
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
  Future<Either<Failure, LoginResponse>> postLogin(BuildContext context, LoginParams loginParams) async {
    try {
      const endpoint = EndPoints.login;
      final response = await DioHelper.postData(
        endPoint: endpoint,
        data: loginParams.toMap(),
        context: context,
        //  formDataIsEnabled: true,
      );
      final responseModel = LoginResponse.fromJson(response.data);
      if (responseModel.status == 1) {
        Constants.customerId = responseModel.data?.id.toString();
        return right(responseModel);
      } else {
        // ConstantsModels.requiredValidationModel = RegisterModel.fromJson(response.data);
        // Constants.customerId = response.data['data']['id'].toString();
        return left(
          ServerFailure(responseModel.message??'error in login'),
        );
      }
      // Now check if the response indicates success or an error
    } catch (error) {
      log(error.toString());

      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      }
      return left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgetPassword(BuildContext context, {required String phone}) async {
    try {
      const String endpoint = EndPoints.forgetPassword;
      await DioHelper.postData(
        endPoint: endpoint,
        context: context,
        data: {
          'phone': phone,
        },
      );

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
  Future<Either<Failure, String>> resendCode(BuildContext context,
      {required String phone, String? customerId, required bool isLogin}) async {
    try {
      final String endpoint = isLogin ? EndPoints.resendLoginOtp : EndPoints.resendOtp;
      await DioHelper.postData(
        endPoint: endpoint,
        data: {
          'phone': phone,
          'customer_id': customerId,
        },
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
  Future<Either<Failure, String>> resetPasswordPassword(
      BuildContext context, ResetPasswordParams resetPasswordParams) async {
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
