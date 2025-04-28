import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/errors/api_error_model.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:dobzz_seller/main.dart';
import 'package:flutter/material.dart';

abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  final ApiError? apiError;

  ServerFailure(String errMessage, {this.apiError}) : super(errMessage);

  factory ServerFailure.fromDioException(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');
      case DioExceptionType.badResponse:
        // Parse the error response using our ApiError model
        try {
          final statusCode = dioError.response?.statusCode;
          final responseData = dioError.response?.data;

          if (responseData is Map<String, dynamic>) {
            final apiError = ApiError.fromJson(responseData, statusCode: statusCode);
            return ServerFailure(apiError: apiError, apiError.getUserFriendlyMessage());
          } else if (responseData is String) {
            return ServerFailure(responseData);
          }
          return ServerFailure('Bad response: ${statusCode ?? "Unknown"}');
        } catch (e) {
          return ServerFailure('Could not process error response');
        }
      /////////////////////////////////////////////////////
      case DioExceptionType.badCertificate:
        return ServerFailure('Bad Certificate with ApiServer');
      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was canceld');
      case DioExceptionType.connectionError:
        // print('=======> ${Constants.noInternet} <=========');
        //
        // if (!Constants.noInternet) {
        //   navigatorKey.currentState!.pushReplacement(
        //     MaterialPageRoute(
        //       builder: (context) => const StopInternetWidget(),
        //       settings: const RouteSettings(name: 'StopInternetPage'),
        //     ),
        //   );
        // }
        return ServerFailure('No Internet Connection');

      case DioExceptionType.unknown:
        return ServerFailure('Unexpected Error, Please try again!');
      default:
        return ServerFailure('Opps There was an Error, Please try again');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 422 || statusCode == 302) {
      if (response != null &&
          response['message'] != null &&
          (response['message'].toString().toLowerCase().contains('token is expired') ||
              response['message'].toString().toLowerCase().contains('authorization token not found'))) {
        try {
          Future.delayed(Duration.zero, () {
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          });
          Constants.token = '';
          userCache?.put(userCacheKey, '{}');
        } catch (e) {
          log('error in put value in hive $e');
        }
      }
      return ServerFailure(response['message'].toString());
    } else if (statusCode == 404) {
      return ServerFailure('Your request not found, Please try later!');
    } else if (statusCode == 500) {
      // log('object::>> ${response}');
      return ServerFailure('Internal Server error, Please try later');
    } else {
      log('what is wrong ==> $response');

      return ServerFailure('Opps There was an Error, Please try again');
    }
  }
}
