import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/slider_data_sourc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(SliderInitial());

  Future<void> getSlider({required BuildContext context}) async {
    emit(SliderLoading());
    await SliderDataSource.getSlider().then(
      (value) async {
        value.fold((l) {
          emit(SliderError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.sliderModel = r;
          emit(SliderSuccess());
        });
      },
    );
  }
}
