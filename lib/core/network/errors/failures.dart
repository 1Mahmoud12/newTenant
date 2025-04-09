import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mamlaka/core/utils/constants.dart';

abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioException(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');
      case DioExceptionType.badResponse:
        log('badResponse on url ${dioError.response?.realUri}');
        log('badResponse on statusCode ${dioError.response?.statusCode}');
        log("badResponse on dataSource ${dioError.response?.data.runtimeType} ''${dioError.response?.data}'' ");

        return ServerFailure.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data != ''
              ? ((arabicLanguage ? dioError.response?.data['MessageAr'] : dioError.response?.data['Message']) ??
                      'Something went wrong, Please try again!') ??
                  'Something went wrong, Please try again!'
              : null,
        );
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
    if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 422) {
      // return ServerFailure(response['error']['message']);
      return ServerFailure(response);
    } else if (statusCode == 404) {
      return ServerFailure('Your request not found, Please try later!');
    } else if (statusCode == 500) {
      // log('object::>> ${response}');
      return ServerFailure('Internal Server error, Please try later');
    } else {
      return ServerFailure('Opps There was an Error, Please try again');
    }
  }
}
