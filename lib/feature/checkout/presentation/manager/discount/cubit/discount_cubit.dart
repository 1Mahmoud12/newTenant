import 'package:bloc/bloc.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/checkout/data/dataSource/disscount_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'discount_state.dart';

class DiscountCubit extends Cubit<DiscountState> {
  DiscountCubit() : super(DiscountInitial());
  TextEditingController discountCode = TextEditingController();
  Future<void> discount({required BuildContext context}) async {
    if (isClosed) return;
    emit(DiscountLoading());
    await DisscountDataSource.discount(discountCode: discountCode.text).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;
          emit(DiscountError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          Utils.showToast(title: r.message.toString(), state: UtilState.success);
          final subTotalPrice = ConstantsModels.checkoutDetailsModel?.subTotalPrice ?? 0;
          ConstantsModels.checkoutDetailsModel?.subTotalPrice = (subTotalPrice - (subTotalPrice * (r.data?.percentage ?? 0) / 100)).round();
          if (isClosed) return;
          emit(DiscountSuccess());
        });
      },
    );
  }
}
