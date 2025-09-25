import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/address/data/dataSourec/address_data_source.dart';
import 'package:dobzz_seller/feature/address/presentation/manager/address/cubit/address_cubit.dart';
import 'package:flutter/material.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  AddAddressCubit() : super(AddAddressInitial());
  TextEditingController nameController = TextEditingController();
  TextEditingController addressNicknameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int cityId = -1;
  String? city;
  String? stateName;
  int stateId = -1;
  bool isDefault = false;
  Future<void> addAddress({required BuildContext context, required AddressCubit addressCubit}) async {
    if (isClosed) return;
    emit(AddAddressLoading());
    await AddressDataSource.addAddress(
      data: {
        'name': nameController.text,
        'address': addressNicknameController.text,
        'phone': phoneController.text,
        // 'city_id': cityId,
        'city': city,
        'state': stateName,
        //'state_id': stateId,
        'is_default': isDefault,
      },
    ).then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(AddAddressError(e: l.errMessage));
        }, (r) async {
          Navigator.pop(context);
          Utils.showToast(
            title: 'Address Add Successfully',
            state: UtilState.success,
          );
          addressCubit.getAddress(context: context);
          if (isClosed) return;
          emit(AddAddressSuccess());
        });
      },
    );
  }

  Future<void> updateAddress({required BuildContext context, required AddressCubit addressCubit, required int addressId}) async {
    if (isClosed) return;
    emit(UpdateAddressLoading());
    await AddressDataSource.updateAddress(
      addressId: addressId,
      data: {
        'name': addressNicknameController.text,
        'phone': phoneController.text,
        'city_id': cityId,
        'state_id': stateId,
        'is_default': isDefault,
        '_method': 'put',
      },
    ).then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(UpdateAddressError(e: l.errMessage));
        }, (r) async {
          Navigator.pop(context);
          Utils.showToast(
            title: 'Address updated Successfully',
            state: UtilState.success,
          );
          addressCubit.getAddress(context: context);
          if (isClosed) return;
          emit(UpdateAddressSuccess());
        });
      },
    );
  }
}
