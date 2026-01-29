import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/data/models/orders_list_model.dart';

class OrdersListDataSource {
  static Future<Either<Failure, OrdersListModel>> getOrdersList() async {
    try {
      final customerId = Constants.customerId;

      final response = await DioHelper.postData(
        endPoint: 'order-list',
        query: {
          'theme_id': 'grocery',
          if (customerId != null) 'customer_id': customerId,
        },
        data: {},
      );

      final model = OrdersListModel.fromJson(response.data);
      return Right(model);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
