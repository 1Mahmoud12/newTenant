// ignore_for_file: type_annotate_public_apis
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class DioHelper {
  static Dio? dio;

  // ignore: always_declare_return_types
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  // get dataSource ====>>>
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    BuildContext? context,
    String? isolateToken,
  }) async {
    final String token = isolateToken ?? Constants.token;
    debugPrint('token: $token');
    dio!.options.headers = {
      if (token != '') 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'domain': Constants.subdomain,
      'Apipassword': Constants.apiPassword,
      'lang': Constants.currentLanguage,
      'uuid': Constants.deviceId,
      //'uuid': userCache?.get(deviceIdKey, defaultValue: ''),
    };
    log('=======================================================');
    log('${dio?.options.baseUrl}$url');
    log('َQuery ====> $query');
    log('Headers in get method ${dio!.options.headers}');

    log('=======================================================');

    return dio!
        .get(
      url,
      queryParameters: query,
    )
        .then(
      (value) {
        if (value.data['status'] == 0) {
          throw value.data['detail'];
        }
        printDM('Response post Method ==== \n ${value.realUri}');

        debugPrint('Success Data (${value.data['StatusCode']}) ===> ${value.data['Data']}');
        return value;
      },
    );
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
    final String token = Constants.token;

    debugPrint('token: $token');
    dio!.options.headers = {
      if (token != '') 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'subdomain': Constants.subdomain,
      'Apipassword': Constants.apiPassword,
      'lang': Constants.currentLanguage,
      'uuid': Constants.deviceId,
      // 'uuid': userCache?.get(deviceIdKey, defaultValue: ''),
    };

    log('=======================================================');
    log('Headers in post method ${dio!.options.baseUrl}/$endPoint');
    log('Headers in post method ${dio!.options.headers}');
    log('Data in post method ');
    if (formDataIsEnabled) {
      final FormData formData = FormData.fromMap(data);

      for (final field in formData.fields) {
        log('Field: ${field.key}: ${field.value}');
      }

      for (final file in formData.files) {
        log('File: ${file.key}: ${file.value.filename}, ${file.value.contentType}');
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
      printDM('Response post Method ==== \n $value');
      printDM('statusMessage ==> ${value.statusMessage}');

      if (context != null) {}
      // if (value.data['StatusCode'] == 200) {
      //   debugPrint('Success Data (${value.data['StatusCode']}) ===> ${value.data['Data']}');
      // }

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
    //final String token = HiveReuse.mainBox.get(AppConst.tokenBox) ?? '';
    dio!.options.headers = {
      'Authorization': 'Bearer ${Constants.token}',
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Apipassword': Constants.apiPassword,
      'subdomain': Constants.subdomain,
      'uuid': Constants.deviceId,
      // 'uuid': userCache?.get(deviceIdKey, defaultValue: ''),
    };
    log('=======================================================');
    log('Headers in put method ${dio!.options.baseUrl}/$endPoint');
    log('Headers in put method ${dio!.options.headers}');
    log('Data in put method $data');
    log('=======================================================');
    log('Headers ====> ${dio!.options.headers}');

    return dio!
        .put(
      endPoint,
      queryParameters: query,
      data: formDataIsEnabled ? FormData.fromMap(data) : data,
    )
        .then(
      (value) {
        if (value.data['status'] == 0) {
          throw value.data['detail'];
        }
        debugPrint('Success Data (${value.data['StatusCode']}) ===> ${value.data['Data']}');
        return value;
      },
    );
  }

  // deleteData ====>>>
  static Future<Response> deleteData({
    required String endPoint,
    Map<String, dynamic>? query,
    bool formDataIsEnabled = false,
    required Map<String, dynamic> data,
  }) async {
    final String token = Constants.token;

    // final String token = HiveReuse.mainBox.get(AppConst.tokenBox) ?? '';
    dio!.options.headers = {
      if (token != '') 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'subdomain': Constants.subdomain,
      'Apipassword': Constants.apiPassword,
      'lang': Constants.currentLanguage,
      'uuid': Constants.deviceId,
      // 'uuid': userCache?.get(deviceIdKey, defaultValue: ''),
    };
    log('=======================================================');
    log('Headers in delete method ${dio!.options.baseUrl}/$endPoint');
    log('Headers in delete method ${dio!.options.headers}');
    log('Data in delete method $data');
    log('=======================================================');
    return dio!
        .delete(
      endPoint,
      queryParameters: query,
      data: formDataIsEnabled ? FormData.fromMap(data) : data,
    )
        .then(
      (value) {
        if (value.data['status'] == 0) {
          throw value.data['detail'];
        }
        debugPrint('Success Data (${value.data['StatusCode']}) ===> ${value.data['Data']}');
        return value;
      },
    );
  }

  static Future<String> loadMockData({required String fileName, required BuildContext context}) async {
    final String filePath = 'assets/endpoints/$fileName.json';
    final String jsonString = await DefaultAssetBundle.of(context).loadString(filePath);
    return jsonString;
  }

  static Future<Map<String, dynamic>> makeNetworkRequest({required String endpoint, required BuildContext context}) async {
    final String mockData = await loadMockData(fileName: endpoint, context: context);
    // Parse the mock dataSource into a JSON object
    final Map<String, dynamic> jsonData = json.decode(mockData);
    // Convert the JSON dataSource into a model object or use it directly
    log(jsonData.toString());
    return jsonData;
  }
}
