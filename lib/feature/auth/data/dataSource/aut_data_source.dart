import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/errors/api_error_model.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:dobzz_seller/feature/auth/verifyCode/view/presentation/verify_code_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/auth/data/models/country_code_model.dart';
import 'package:dobzz_seller/feature/auth/data/models/login_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/register_model.dart';
import 'package:dobzz_seller/feature/auth/data/models/reset_password_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/sign_up_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/verify_code_model.dart';

abstract class AuthDataSource {
  Future<Either<Failure, CountryCodeModel>> getCountryCode();

  Future<Either<Failure, String>> forgetPassword(BuildContext context, {required String email});

  Future<Either<Failure, String>> resendCode(BuildContext context, {required String customerId});

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
        options: Options(
          validateStatus: (status) {
            // Consider all responses below 500 as "valid" responses
            // This allows us to handle error responses in our code rather than
            // having Dio throw exceptions for 4xx responses
            return status != null && status < 500;
          },
        ),
      );

      // Now check if the response indicates success or an error
      final statusCode = response.statusCode;
      log('A7a========>$response');
      // Success case
      if (statusCode! == 200 && response.data['status']) {
        log('Success response: ${response.data}');
        return right('');
      }
      // Error case - we get here because we're treating 4xx as valid responses
      else {
        log('Error response: ${response.data}');
        if (response.data is Map<String, dynamic>) {
          final apiError = ApiError.fromJson(response.data, statusCode: statusCode);
          return left(
            ServerFailure(
              apiError.getUserFriendlyMessage(),
              apiError: apiError,
            ),
          );
        }
        return left(ServerFailure('Error $statusCode: ${response.statusMessage}'));
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
      // Now check if the response indicates success or an error
      final statusCode = response.statusCode;
      log('A7a========>$response');
      // Success case
      if (statusCode! == 200 && response.data['status']) {
        log('Success response: ${response.data}');
        return right(RegisterModel.fromJson(response.data));
      } else if (response.data['status'] == false && response.data['message'] == 'You have To Verify Your Phone') {
        ConstantsModels.requiredValidationModel = RegisterModel.fromJson(response.data);
        return left(
          ServerFailure(
            'You have To Verify Your Phone',
            apiError: ApiError.fromJson(response.data, statusCode: statusCode),
          ),
        );
      }
      // Error case - we get here because we're treating 4xx as valid responses
      else {
        log('Error response: ${response.data}');
        if (response.data is Map<String, dynamic>) {
          final apiError = ApiError.fromJson(response.data, statusCode: statusCode);
          return left(
            ServerFailure(
              apiError.getUserFriendlyMessage(),
              apiError: apiError,
            ),
          );
        }
        return left(ServerFailure('Error $statusCode: ${response.statusMessage}'));
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
  Future<Either<Failure, String>> forgetPassword(BuildContext context, {required String email}) async {
    try {
      const String endpoint = EndPoints.forgetPassword;
      await DioHelper.postData(
        endPoint: endpoint,
        context: context,
        data: {
          'email': email,
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
  Future<Either<Failure, String>> resendCode(BuildContext context, {required String customerId}) async {
    try {
      const String endpoint = EndPoints.resendOtp;
      await DioHelper.postData(
        endPoint: endpoint,
        data: {
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
