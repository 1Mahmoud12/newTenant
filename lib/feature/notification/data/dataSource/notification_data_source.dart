import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/notification/data/models/notifications_model.dart';
import 'package:easy_localization/easy_localization.dart';

abstract class NotificationDataSource {
  Future<Either<Failure, NotificationsModel>> getNotifications();

  Future<Either<Failure, String>> markAllRead();

  Future<Either<Failure, String>> markAsRead({required String notificationId});
}

class NotificationDataSourceImpl implements NotificationDataSource {
  @override
  Future<Either<Failure, NotificationsModel>> getNotifications() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.getNotifications);
      return Right(NotificationsModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> markAllRead() async {
    try {
      await DioHelper.postData(
        endPoint: EndPoints.markAllRead,
        data: {},
      );
      return Right('read_all_notifications_successfully'.tr());
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> markAsRead({required String notificationId}) async {
    try {
      await DioHelper.postData(
        endPoint: EndPoints.markAsRead,
        data: {
          'notification_id': notificationId,
        },
      );
      return Right('read_all_notifications_successfully'.tr());
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
