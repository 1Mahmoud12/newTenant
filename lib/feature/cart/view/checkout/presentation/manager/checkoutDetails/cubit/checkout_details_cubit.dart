import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/dataSource/checkout_details_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'checkout_details_state.dart';

class CheckoutDetailsCubit extends Cubit<CheckoutDetailsState> {
  CheckoutDetailsCubit() : super(CheckoutDetailsInitial());

  Future<void> getCheckoutDetails({required BuildContext context}) async {
    emit(CheckoutDetailsLoading());
    await CheckoutDetailsDataSource.getCheckoutDetails().then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          emit(CheckoutDetailsError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.checkoutDetailsModel = r;
          emit(CheckoutDetailsSuccess());
        });
      },
    );
  }
}
