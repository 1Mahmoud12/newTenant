import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/address/data/dataSourec/address_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../data/models/add_address_params.dart';
import '../../address/cubit/address_cubit.dart';
import 'package:dobzz_seller/feature/address/data/models/address_state_model.dart';
import 'package:dobzz_seller/feature/address/data/models/country_model.dart';
import 'package:dobzz_seller/feature/address/data/models/address_city_model.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  AddAddressCubit() : super(AddAddressInitial());
  TextEditingController nameController = TextEditingController();
  TextEditingController addressNicknameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int cityId = -1;
  TextEditingController city =
      TextEditingController(); // This might be used for manual entry or displaying name
  TextEditingController stateName = TextEditingController();
  int stateId = -1;
  TextEditingController countryController = TextEditingController();
  int countryId = -1;
  TextEditingController postCodeController = TextEditingController();
  bool isDefault = false;

  List<CountryModel> countries = [];
  List<AddressStateModel> states = [];
  List<AddressCityModel> cities = [];

  LatLng? selectedLocation;

  Future<void> getCountries() async {
    emit(CountriesLoading());
    final result = await AddressDataSource.getCountries();
    result.fold(
      (l) {
        Utils.showToast(title: l.errMessage, state: UtilState.error);
        emit(CountriesError(e: l.errMessage));
      },
      (r) {
        countries = r;
        emit(CountriesLoaded());
      },
    );
  }

  Future<void> getStates(int countryId) async {
    if (this.countryId == -1) {
      Utils.showToast(
        title: 'please_select_country_first'.tr(),
        state: UtilState.error,
      );
      return;
    }
    emit(StatesLoading());
    final result = await AddressDataSource.getStates(countryId: countryId);
    result.fold(
      (l) {
        Utils.showToast(title: l.errMessage, state: UtilState.error);
        emit(StatesError(e: l.errMessage));
      },
      (r) {
        states = r;
        emit(StatesLoaded());
      },
    );
  }

  Future<void> getCities(int stateId) async {
    if (countryId == -1) {
      Utils.showToast(
        title: 'please_select_country_first'.tr(),
        state: UtilState.error,
      );
      return;
    }
    if (this.stateId == -1) {
      Utils.showToast(
        title: 'please_select_state_first'.tr(),
        state: UtilState.error,
      );
      return;
    }
    emit(CitiesLoading());
    final result = await AddressDataSource.getCities(stateId: stateId);
    result.fold(
      (l) {
        Utils.showToast(title: l.errMessage, state: UtilState.error);
        emit(CitiesError(e: l.errMessage));
      },
      (r) {
        cities = r;
        emit(CitiesLoaded());
      },
    );
  }

  bool validateLocationSelection() {
    if (countryId == -1) {
      Utils.showToast(
        title: 'please_select_country'.tr(),
        state: UtilState.error,
      );
      return false;
    }
    if (stateId == -1) {
      Utils.showToast(
        title: 'please_select_state'.tr(),
        state: UtilState.error,
      );
      return false;
    }
    if (cityId == -1) {
      Utils.showToast(
        title: 'please_select_city'.tr(),
        state: UtilState.error,
      );
      return false;
    }
    return true;
  }

  Future<void> addAddress({required BuildContext context, required AddressCubit addressCubit}) async {
    if (isClosed) return;
    emit(AddAddressLoading());
    await AddressDataSource.addAddress(
      data: AddAddressParams(
        themeId: 'grocery',
        customerId: Constants.customerId ?? '',
        title: nameController.text,
        address: addressNicknameController.text,
        country: countryId.toString(),
        state: stateId.toString(),
        city: cityId.toString(),
        postcode: postCodeController.text,
        isDefault: isDefault,
      ),
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

  Future<void> updateAddress(
      {required BuildContext context,
      required AddressCubit addressCubit,
      required int addressId}) async {
    if (isClosed) return;
    emit(UpdateAddressLoading());
    await AddressDataSource.updateAddress(
      addressId: addressId,
      data: AddAddressParams(
        themeId: 'grocery',
        customerId: Constants.customerId ?? '',
        title: nameController.text,
        address: addressNicknameController.text,
        country: countryId.toString(),
        state: stateId.toString(),
        city: cityId.toString(),
        postcode: postCodeController.text,
        isDefault: isDefault,
      ),

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
