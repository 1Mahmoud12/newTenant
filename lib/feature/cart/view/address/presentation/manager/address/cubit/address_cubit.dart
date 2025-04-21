import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/cart/view/address/data/dataSourec/address_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  Future<void> getAddress({required BuildContext context}) async {
    emit(AddressLoading());
    await AddressDataSource.getAddress().then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          emit(AddressError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.addressModel = r;
          emit(AddressSuccess());
        });
      },
    );
  }
}
