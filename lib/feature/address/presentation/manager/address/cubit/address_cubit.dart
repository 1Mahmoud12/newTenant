import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/address/data/dataSourec/address_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  Future<void> getAddress({required BuildContext context}) async {
    if (isClosed) return;
    emit(AddressLoading());
    await AddressDataSource.getAddress().then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;
          //   Utils.showToast(title: l.errMessage, state: UtilState.error);
          emit(AddressError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.addressModel = r;
          log('print address ====>${ConstantsModels.addressModel?.toJson()}');
          log('default address ====>${Constants.defaultAddress.addressId}');
          if (isClosed) return;
          emit(AddressSuccess());
        });
      },
    );
  }

  Future<void> deleteAddress({required BuildContext context, required int addressId}) async {
    if (isClosed) return;
    emit(DeleteAddressLoading());
    await AddressDataSource.deleteAddress(addressId: addressId).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          emit(DeleteAddressError(e: l.errMessage));
        }, (r) async {
          Utils.showToast(title: r, state: UtilState.success);
          log('print address ====>${ConstantsModels.addressModel?.toJson()}');
          log('default address ====>${Constants.defaultAddress.addressId}');
          if (isClosed) return;
          emit(DeleteAddressSuccess());
        });
      },
    );
  }
}
