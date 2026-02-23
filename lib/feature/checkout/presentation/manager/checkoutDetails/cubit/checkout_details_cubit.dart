import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/checkout/data/dataSource/checkout_details_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'checkout_details_state.dart';

class CheckoutDetailsCubit extends Cubit<CheckoutDetailsState> {
  CheckoutDetailsCubit() : super(CheckoutDetailsInitial());

  Future<void> getCheckoutDetails({required BuildContext context}) async {
    if (isClosed) return;
    emit(CheckoutDetailsLoading());
    await CheckoutDetailsDataSource.getCheckoutDetails().then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(CheckoutDetailsError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.checkoutDetailsModel = r;
          if (isClosed) return;
          emit(CheckoutDetailsSuccess());
        });
      },
    );
  }
}
