import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/checkout/data/dataSource/process_to_checkout_data_source.dart';
import 'package:dobzz_seller/feature/checkout/data/models/place_order_model.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/utils.dart';
import '../../../../../navigation/view/presentation/navigation_view.dart';

part 'process_to_checkout_state.dart';

class ProcessToCheckoutCubit extends Cubit<ProcessToCheckoutState> {
  ProcessToCheckoutCubit() : super(ProcessToCheckoutInitial());
  String addressId = Constants.defaultAddress.addressId.toString();
  ProcessToCheckoutDataSource processToCheckoutDataSource =
      ProcessToCheckoutDataSourceImpl();
  int orderId = -1;

  Future<void> placeOrder({
    required BuildContext context,
    required PlaceOrderBodyModel body,
  }) async {
    if (isClosed) return;
    emit(ProcessToCheckoutLoading());

    final result = await processToCheckoutDataSource.placeOrder(body: body);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(ProcessToCheckoutError(e: failure.errMessage));
        Utils.showToast(title: failure.errMessage, state: UtilState.error);
      },
      (response) {
        if (isClosed) return;
        orderId = response.data?.orderId ?? -1;
        emit(ProcessToCheckoutSuccess());
        Utils.showToast(
            title: response.message ?? 'Order Placed Successfully',
            state: UtilState.success);
        context.navigateToPage(NavigationViewWithThemes());
        // Navigate or perform other actions on success
      },
    );
  }
}
