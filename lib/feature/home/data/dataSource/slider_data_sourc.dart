import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rova_star/core/network/dio_helper.dart';
import 'package:rova_star/core/network/end_points.dart';
import 'package:rova_star/core/network/errors/failures.dart';
import 'package:rova_star/feature/home/data/models/slider_model.dart';

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
}
