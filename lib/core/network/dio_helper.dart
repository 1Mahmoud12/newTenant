// ignore_for_file: type_annotate_public_apis
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// ignore: avoid_classes_with_only_static_members
class DioHelper {
  static Dio? dio;

  // ignore: always_declare_return_types
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
      ),
    );

    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request details
          log('🌐 REQUEST[${options.method}] => ${options.uri}');
          log('📤 Headers: ${options.headers}');
          if (options.data != null) {
            log('📦 Body: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response details
          log('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}');

          final contentType = response.headers.value('content-type');
          if (contentType?.contains('text/html') == true) {
            log('⚠️ HTML detected in response!');
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
                error: 'server_returned_html_instead_of_json'.tr(),
              ),
            );
          }
          if (response.data is String) {
            final data = (response.data as String).trim().toLowerCase();
            if (data.startsWith('<!doctype') || data.startsWith('<html')) {
              log('⚠️ HTML content detected in response body!');
              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  response: response,
                  type: DioExceptionType.badResponse,
                  error: 'server_returned_html_instead_of_json'.tr(),
                ),
              );
            }
          }

          return handler.next(response);
        },
        onError: (error, handler) {
          // Log error details
          log('❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.uri}');
          log('💥 Error Type: ${error.type}');
          log('💥 Error Message: ${error.message}');

          return handler.next(error);
        },
      ),
    );
    // ✅ Pretty Logger
    dio?.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
    );
    // 🔥 Retry Interceptor للأخطاء المؤقتة
    dio?.interceptors.add(
      RetryInterceptor(
        dio: dio!,
      ),
    );
  }

  // 🔥 Helper method لبناء Headers
  static Map<String, dynamic> _buildHeaders({String? token}) {
    final String authToken = token ?? Constants.token;
    return {
      if (authToken.isNotEmpty) 'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
      'subdomain': Constants.subdomain,
      'Apipassword': Constants.apiPassword,
      'lang': Constants.currentLanguage,
      'uuid': Constants.deviceId,
    };
  }

  // get dataSource ====>>>
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    BuildContext? context,
    String? isolateToken,
  }) async {
    dio!.options.headers = _buildHeaders(token: isolateToken);

    log('=======================================================');
    log('GET: ${dio?.options.baseUrl}$url');
    log('Query: $query');
    log('Headers: ${dio!.options.headers}');
    log('=======================================================');

    return dio!.get(url, queryParameters: query).then((value) {
      if (value.data is Map && value.data['status'] == 0) {
        throw DioException(
          requestOptions: value.requestOptions,
          response: value,
          type: DioExceptionType.badResponse,
          error: value.data['detail'] ?? 'unknown_error'.tr(),
        );
      }
      logger.i('Success Data (${value.statusCode}) ===> ${value.data['Data']}');

      return value;
    });
  }

  // post dataSource ====>>>
  static Future<Response> postData({
    required String endPoint,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    bool formDataIsEnabled = false,
    String? jsonEncode,
    BuildContext? context,
    Options? options,
  }) async {
    dio!.options.headers = _buildHeaders();

    log('=======================================================');
    log('POST: ${dio!.options.baseUrl}/$endPoint');
    log('Headers: ${dio!.options.headers}');

    if (formDataIsEnabled) {
      final FormData formData = FormData.fromMap(data);
      log('📋 FormData Fields:');
      for (final field in formData.fields) {
        log('  ${field.key}: ${field.value}');
      }
      log('📎 FormData Files:');
      for (final file in formData.files) {
        log('  ${file.key}: ${file.value.filename}, ${file.value.contentType}');
      }
    } else {
      log('Data: $data');
    }
    log('=======================================================');

    return dio!
        .post(
      '${EndPoints.baseUrl}$endPoint',
      queryParameters: query,
      data: jsonEncode ?? (formDataIsEnabled ? FormData.fromMap(data) : data),
      options: options,
    )
        .then((value) {
      printDM('Response POST Method ==== \n $value');
      printDM('statusMessage ==> ${value.statusMessage}');
      return value;
    });
  }

  // putData ====>>>
  static Future<Response> putData({
    required String endPoint,
    Map<String, dynamic>? query,
    bool formDataIsEnabled = false,
    required Map<String, dynamic> data,
  }) async {
    dio!.options.headers = _buildHeaders();

    log('=======================================================');
    log('PUT: ${dio!.options.baseUrl}/$endPoint');
    log('Headers: ${dio!.options.headers}');
    log('Data: $data');
    log('=======================================================');

    return dio!
        .put(
      endPoint,
      queryParameters: query,
      data: formDataIsEnabled ? FormData.fromMap(data) : data,
    )
        .then((value) {
      if (value.data is Map && value.data['status'] == 0) {
        throw DioException(
          requestOptions: value.requestOptions,
          response: value,
          type: DioExceptionType.badResponse,
          error: value.data['detail'] ?? 'unknown_error'.tr(),
        );
      }
      debugPrint('Success Data (${value.data['StatusCode']}) ===> ${value.data['Data']}');
      return value;
    });
  }

  // deleteData ====>>>
  static Future<Response> deleteData({
    required String endPoint,
    Map<String, dynamic>? query,
    bool formDataIsEnabled = false,
    required Map<String, dynamic> data,
  }) async {
    dio!.options.headers = _buildHeaders();

    log('=======================================================');
    log('DELETE: ${dio!.options.baseUrl}/$endPoint');
    log('Headers: ${dio!.options.headers}');
    log('Data: $data');
    log('=======================================================');

    return dio!
        .delete(
      endPoint,
      queryParameters: query,
      data: formDataIsEnabled ? FormData.fromMap(data) : data,
    )
        .then((value) {
      if (value.data is Map && value.data['status'] == 0) {
        throw DioException(
          requestOptions: value.requestOptions,
          response: value,
          type: DioExceptionType.badResponse,
          error: value.data['detail'] ?? 'unknown_error'.tr(),
        );
      }
      debugPrint('Success Data (${value.data['StatusCode']}) ===> ${value.data['Data']}');
      return value;
    });
  }

  static Future<String> loadMockData({
    required String fileName,
    required BuildContext context,
  }) async {
    final String filePath = 'assets/endpoints/$fileName.json';
    final String jsonString = await DefaultAssetBundle.of(context).loadString(filePath);
    return jsonString;
  }

  static Future<Map<String, dynamic>> makeNetworkRequest({
    required String endpoint,
    required BuildContext context,
  }) async {
    final String mockData = await loadMockData(fileName: endpoint, context: context);
    final Map<String, dynamic> jsonData = json.decode(mockData);
    log(jsonData.toString());
    return jsonData;
  }
}

// 🔥 Retry Interceptor للمحاولات التلقائية
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    this.retries = 2,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
    ],
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry on specific status codes or connection errors
    if (_shouldRetry(err)) {
      final attempt = err.requestOptions.extra['retry_attempt'] ?? 0;

      if (attempt < retries) {
        log('🔄 Retrying request (${attempt + 1}/$retries): ${err.requestOptions.uri}');

        // Wait before retry
        final delay = retryDelays[attempt < retryDelays.length ? attempt : retryDelays.length - 1];
        await Future.delayed(delay);

        // Update retry count
        err.requestOptions.extra['retry_attempt'] = attempt + 1;

        try {
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          // If retry fails, continue to next retry or return error
          if (e is DioException) {
            return onError(e, handler);
          }
        }
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Retry on connection errors or specific status codes
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.response?.statusCode == 502 ||
        err.response?.statusCode == 503 ||
        err.response?.statusCode == 504 ||
        err.response?.statusCode == 522 ||
        err.response?.statusCode == 524;
  }
}
