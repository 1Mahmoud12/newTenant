import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/errors/api_error_model.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:dobzz_seller/main.dart';
import 'package:easy_localization/easy_localization.dart';
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
        return ServerFailure('connection_timeout_error'.tr());

      case DioExceptionType.sendTimeout:
        return ServerFailure('send_timeout_error'.tr());

      case DioExceptionType.receiveTimeout:
        return ServerFailure('receive_timeout_error'.tr());

      case DioExceptionType.badResponse:
        return _handleBadResponse(dioError);

      case DioExceptionType.badCertificate:
        return ServerFailure('bad_certificate_error'.tr());

      case DioExceptionType.cancel:
        return ServerFailure('request_cancelled_error'.tr());

      case DioExceptionType.connectionError:
        return ServerFailure('no_internet_connection'.tr());

      case DioExceptionType.unknown:
        return ServerFailure('unexpected_error_try_again'.tr());
    }
  }

  static ServerFailure _handleBadResponse(DioException dioError) {
    try {
      final statusCode = dioError.response?.statusCode;
      final responseData = dioError.response?.data;
      final contentType = dioError.response?.headers.value('content-type');

      if (contentType?.contains('text/html') == true) {
        return _handleHtmlError(statusCode, responseData);
      }

      if (responseData is Map<String, dynamic>) {
        return _handleJsonError(statusCode, responseData);
      }

      if (responseData is String) {
        if (responseData.trim().toLowerCase().startsWith('<!doctype') || responseData.trim().toLowerCase().startsWith('<html')) {
          return _handleHtmlError(statusCode, responseData);
        }
        return ServerFailure(_getSafeErrorMessage(responseData));
      }

      return ServerFailure('bad_response_error'.tr());
    } catch (e) {
      log('Error in _handleBadResponse: $e');
      return ServerFailure('unable_to_process_response'.tr());
    }
  }

  static ServerFailure _handleHtmlError(int? statusCode, dynamic htmlContent) {
    log('⚠️ Server returned HTML instead of JSON - Status: $statusCode');

    switch (statusCode) {
      case 520:
        return ServerFailure('cloudflare_unknown_error'.tr());
      case 521:
        return ServerFailure('server_is_down'.tr());
      case 522:
        return ServerFailure('server_not_responding'.tr());
      case 523:
        return ServerFailure('server_unreachable'.tr());
      case 524:
        return ServerFailure('server_timeout_error'.tr());
      case 525:
        return ServerFailure('ssl_handshake_failed'.tr());
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure('server_temporary_issue'.tr());
      default:
        return ServerFailure('server_connection_error'.tr());
    }
  }

  static ServerFailure _handleJsonError(int? statusCode, Map<String, dynamic> responseData) {
    if (_isTokenError(statusCode, responseData)) {
      _handleTokenExpired();
      return ServerFailure('session_expired_login_again'.tr());
    }

    try {
      final apiError = ApiError.fromJson(responseData, statusCode: statusCode);
      final errorMessage = apiError.getUserFriendlyMessage();
      logger.e('API Error: $errorMessage');
      return ServerFailure(errorMessage, apiError: apiError);
    } catch (e) {
      return _getDefaultErrorByStatusCode(statusCode, responseData);
    }
  }

  static bool _isTokenError(int? statusCode, Map<String, dynamic> responseData) {
    final message = responseData['message']?.toString().toLowerCase() ?? '';
    return message.contains('token not found') ||
        message.contains('authorization token not found') ||
        message.contains('unauthenticated') ||
        message.contains('unauthorized');
  }

  static void _handleTokenExpired() {
    try {
      Future.delayed(Duration.zero, () {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      });
      Constants.token = '';
      userCache?.put(loginCacheKey, '{}');
    } catch (e) {
      log('Error in _handleTokenExpired: $e');
    }
  }

  static ServerFailure _getDefaultErrorByStatusCode(
    int? statusCode,
    Map<String, dynamic>? responseData,
  ) {
    final message = responseData?['message']?.toString();
    final data = responseData?['data']?.toString();

    if (message != null && message.isNotEmpty) {
      return ServerFailure(_getSafeErrorMessage(message));
    }

    if (data != null && data.isNotEmpty) {
      return ServerFailure(_getSafeErrorMessage(data));
    }

    switch (statusCode) {
      case 400:
        return ServerFailure('invalid_request_data'.tr());
      case 401:
        return ServerFailure('please_login_first'.tr());
      case 403:
        return ServerFailure('no_permission_for_action'.tr());
      case 404:
        return ServerFailure('resource_not_found'.tr());
      case 422:
        return ServerFailure('validation_error'.tr());
      case 500:
        return ServerFailure('internal_server_error'.tr());
      case 502:
        return ServerFailure('bad_gateway_error'.tr());
      case 503:
        return ServerFailure('service_unavailable'.tr());
      default:
        return ServerFailure('something_went_wrong'.tr());
    }
  }

  static String _getSafeErrorMessage(String message) {
    final cleanMessage = message.replaceAll(RegExp(r'<[^>]*>'), '');

    if (cleanMessage.length > 200) {
      return 'something_went_wrong'.tr();
    }

    return cleanMessage.trim().isEmpty ? 'something_went_wrong'.tr() : cleanMessage.trim();
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (response is Map<String, dynamic>) {
      return _handleJsonError(statusCode, response);
    }
    return _getDefaultErrorByStatusCode(statusCode, null);
  }
}
