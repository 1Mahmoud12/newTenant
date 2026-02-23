import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rova_star/core/network/dio_helper.dart';
import 'package:rova_star/core/network/end_points.dart';
import 'package:rova_star/core/network/errors/failures.dart';
import 'package:rova_star/feature/address/data/models/state_model.dart';

class StateDataSource {
  static Future<Either<Failure, StateModel>> getState() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.state);
      return Right(StateModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
