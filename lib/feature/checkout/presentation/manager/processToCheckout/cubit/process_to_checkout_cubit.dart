import 'package:bloc/bloc.dart';
import 'package:rova_star/core/utils/constants.dart';
import 'package:rova_star/feature/checkout/data/dataSource/process_to_checkout_data_source.dart';
import 'package:flutter/material.dart';

part 'process_to_checkout_state.dart';

class ProcessToCheckoutCubit extends Cubit<ProcessToCheckoutState> {
  ProcessToCheckoutCubit() : super(ProcessToCheckoutInitial());
  String addressId = Constants.defaultAddress.addressId.toString();
  ProcessToCheckoutDataSource processToCheckoutDataSource = ProcessToCheckoutDataSourceImpl();
  int orderId = -1;

  Future<void> processToCheckout({required BuildContext context}) async {
    if (isClosed) return;
    emit(ProcessToCheckoutLoading());

    // await processToCheckoutDataSource.processToCheckout(addressId: addressId).then(
    //   (value) async {
    //     value.fold((l) {
    //       if (isClosed) return;
    //       emit(ProcessToCheckoutError(e: l.errMessage));
    //       Utils.showToast(title: l.errMessage, state: UtilState.error);
    //     }, (r) async {
    //       orderId = r;
    //
    //       if (isClosed) return;
    //       emit(ProcessToCheckoutSuccess());
    //     });
    //   },
    // );
  }
}
