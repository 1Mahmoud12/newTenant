import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/dio_helper.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/network/local/cache.dart';
import '../../../../core/utils/utils.dart';

class AddToCartDataSource {
  static Future<Either<Failure, void>> addToCart({required int productId, required int quantity, required int variantId}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.addToCart,
        query: {
          'theme_id': 'grocery',
          'customer_id': loginCacheValue?.data?.id.toString(),
          'product_id': productId.toString(),
          'qty': quantity.toString(),
          'variant_id': variantId.toString(),
        }, data: {},
      );
      if (response.data['status'] != 1) {
        log('add to cart Response: ${response.data}');
        return Left(ServerFailure(response.data['message']));
      }
      Utils.showToast(title: response.data['message'], state: UtilState.success);
      log('add to cart Response: ${response.data}');
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, void>> updateCartItem({required int cartItemId, required int quantity,required bool? isIncrease,required int variantId}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: '${EndPoints.cartQty}',
        query: {
          'theme_id': 'grocery',
          'customer_id': loginCacheValue?.data?.id.toString(),
          'product_id': cartItemId.toString(),
          'qty': quantity.toString(),
          'quantity_type': isIncrease == null ?'remove':isIncrease ? 'increase' : 'decrease',
          'variant_id': variantId.toString(),
        }, data: {},
      );
      if (response.data['status'] != 1) {
        log('add to cart Response: ${response.data}');
        return Left(ServerFailure(response.data['message']));
      }
      Utils.showToast(title: 'cart_updated_successfully'.tr(), state: UtilState.success);
      log('add to cart Response: ${response.data}');
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
