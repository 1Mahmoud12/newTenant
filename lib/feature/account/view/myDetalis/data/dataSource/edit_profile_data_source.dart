import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/account/view/myDetalis/data/models/edit_profile_model.dart';

class EditProfileDataSource {
  static Future<Either<Failure, EditProfileModel>> getUserData() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.editProfile);
      log(' Response: ${response.data['data']}');
      return Right(EditProfileModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, void>> updateUserData({required Map<String, dynamic> data}) async {
    try {
      final response = await DioHelper.postData(formDataIsEnabled: true, endPoint: EndPoints.editProfile, data: data);
      log(' Response: ${response.data['data']}');
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
