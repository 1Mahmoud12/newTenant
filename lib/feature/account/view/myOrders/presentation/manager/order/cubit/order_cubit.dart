import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/data/dataSource/order_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  Future<void> getOrders({required BuildContext context}) async {
    emit(OrderLoading());
    await OrderDataSource.getOrders().then(
      (value) async {
        value.fold((l) {
          emit(OrderError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.orderModel = r;
          emit(OrderSuccess());
        });
      },
    );
  }
}
