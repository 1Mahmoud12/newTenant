import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/account/view/notificationSetting/data/models/general_notification_setting_model.dart';

class GetGeneralNotiSettingDataSource {
  static Future<Either<Failure, GeneralNotificationModel>> getGeneralNotiSetting() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.getNotificationSetting);
      log('Response: ${response.data['data']}');
      return Right(GeneralNotificationModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, void>> updateNotificationSetting({required Map<String,dynamic>data}) async {
    try {
      final response = await DioHelper.postData(endPoint: EndPoints.getNotificationSetting,data: data);
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
