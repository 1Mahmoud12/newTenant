import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/cart/view/address/data/dataSourec/state_data_soruce.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'state_state.dart';

class StateCubit extends Cubit<StateState> {
  StateCubit() : super(StateInitial());

  Future<void> getAddress({required BuildContext context}) async {
    emit(StateLoading());
    await StateDataSource.getState().then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          emit(StateError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.stateModel = r;
          emit(StateSuccess());
        });
      },
    );
  }
}
