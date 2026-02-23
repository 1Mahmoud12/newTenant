import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/address/data/dataSourec/address_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../address/cubit/address_cubit.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  AddAddressCubit() : super(AddAddressInitial());
  TextEditingController nameController = TextEditingController();
  TextEditingController addressNicknameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int cityId = -1;
  TextEditingController city = TextEditingController();
  TextEditingController stateName = TextEditingController();
  int stateId = -1;
  bool isDefault = false;

  LatLng? selectedLocation;

  Future<void> addAddress({required BuildContext context, required AddressCubit addressCubit}) async {
    if (isClosed) return;
    emit(AddAddressLoading());
    await AddressDataSource.addAddress(
      data: {
        'name': nameController.text,
        'address': addressNicknameController.text,
        'phone': phoneController.text,
        'latitude': selectedLocation?.latitude,
        'longitude': selectedLocation?.longitude,
        'city': city.text,
        'state': stateName.text,
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
        'name': nameController.text,
        'address': addressNicknameController.text,
        'phone': phoneController.text,
        'latitude': selectedLocation?.latitude,
        'longitude': selectedLocation?.longitude,
        'city': city.text,
        'state': stateName.text,
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
