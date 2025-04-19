import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/get_top_product_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'top_product_state.dart';

class TopProductCubit extends Cubit<TopProductState> {
  TopProductCubit() : super(TopProductInitial());

  Future<void> getTopProduct({required BuildContext context}) async {
    emit(TopProductLoading());
    await GetTopProductDataSource.getTopProduct().then(
      (value) async {
        value.fold((l) {
          emit(TopProductError(e: l.errMessage));
        }, (r) async {
          //   logger.i(r.toJson());
          ConstantsModels.topProductModel = r;
          log('Top Product: ${ConstantsModels.topProductModel?.data?.length}');

          emit(TopProductSuccess());
        });
      },
    );
  }
}
