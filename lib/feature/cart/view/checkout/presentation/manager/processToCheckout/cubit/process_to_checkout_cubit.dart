import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/my_order_view.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/dataSource/process_to_checkout_data_source.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'process_to_checkout_state.dart';

class ProcessToCheckoutCubit extends Cubit<ProcessToCheckoutState> {
  ProcessToCheckoutCubit() : super(ProcessToCheckoutInitial());
  String addressId = '';
  Future<void> processToCheckout({required BuildContext context}) async {
    emit(ProcessToCheckoutLoading());
    await ProcessToCheckoutDataSource.processToCheckout(addressId: addressId).then(
      (value) async {
        value.fold((l) {
          emit(ProcessToCheckoutError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          context.navigateToPageWithReplacement(
            const NavigationViewWithThemes(
              initialIndex: 1,
            ),
          );
          context.navigateToPage(const MyOrderView());
          emit(ProcessToCheckoutSuccess());
        });
      },
    );
  }
}
