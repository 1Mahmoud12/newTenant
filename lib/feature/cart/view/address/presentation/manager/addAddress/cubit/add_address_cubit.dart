import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/cart/view/address/data/dataSourec/address_data_source.dart';
import 'package:dobzz_seller/feature/cart/view/address/presentation/manager/address/cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  AddAddressCubit() : super(AddAddressInitial());
  TextEditingController addressNicknameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int cityId = -1;
  int stateId = -1;
  bool isDefault = false;
  Future<void> addAddress({required BuildContext context, required AddressCubit addressCubit}) async {if (isClosed) return;
    emit(AddAddressLoading());
    await AddressDataSource.addAddress(
      data: {
        'name': addressNicknameController.text,
        'phone': phoneController.text,
        'city_id': cityId,
        'state_id': stateId,
        'is_default': isDefault,
      },
    ).then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);if (isClosed) return;
          emit(AddAddressError(e: l.errMessage));
        }, (r) async {
          Navigator.pop(context);
          Utils.showToast(
            title: 'Address Add Successfully',
            state: UtilState.success,
          );
          addressCubit.getAddress(context: context);if (isClosed) return;
          emit(AddAddressSuccess());
        });
      },
    );
  }
}
