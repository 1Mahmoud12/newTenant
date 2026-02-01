import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/home/data/models/land_page_model.dart';
import 'package:dobzz_seller/feature/home/data/models/slider_model.dart';

class SliderDataSource {
  static Future<Either<Failure, SliderModel>> getSlider() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.slider);
      return Right(SliderModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, LandPageModel>> getLandPage() async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.landpage,
        data: {},
      );
      return Right(LandPageModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
