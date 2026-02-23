import 'package:bloc/bloc.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/feature/home/data/dataSource/slider_data_sourc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(SliderInitial());

  Future<void> getSlider({required BuildContext context}) async {if (isClosed) return;
    emit(SliderLoading());
    await SliderDataSource.getSlider().then(
      (value) async {
        value.fold((l) {if (isClosed) return;
          emit(SliderError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.sliderModel = r;if (isClosed) return;
          emit(SliderSuccess());
        });
      },
    );
  }
}
