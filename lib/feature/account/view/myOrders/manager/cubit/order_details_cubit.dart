import 'package:dobzz_seller/feature/account/view/myOrders/data/dataSource/order_data_source.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/data/models/order_detail_model.dart';
import 'package:dobzz_seller/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit() : super(OrderDetailsInitial());

  Future<void> getOrderDetails(int orderId) async {
    emit(OrderDetailsLoading());
    final result = await OrderDataSource.getOrderDetail(orderId: orderId);
    result.fold(
      (failure) => emit(OrderDetailsError(failure.errMessage)),
      (model) {
        if (model.data != null) {
          logger.d(model.data);
          emit(OrderDetailsSuccess(model.data!));
        } else {
          emit(OrderDetailsError(model.message ?? 'No data found'));
        }
      },
    );
  }
}
