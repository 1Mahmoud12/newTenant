import 'package:bloc/bloc.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/address/data/dataSourec/city_data_source.dart';
import 'package:flutter/material.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(CityInitial());
  Future<void> getAddress({required BuildContext context, required int stateId}) async {
    if (isClosed) return;
    emit(CityLoading());
    await CityDataSource.getCities(stateId: stateId).then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(CityError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.cityModel = r;
          if (isClosed) return;
          emit(CitySuccess());
        });
      },
    );
  }
}
