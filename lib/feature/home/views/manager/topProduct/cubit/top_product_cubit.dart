import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/get_top_product_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'top_product_state.dart';

class TopProductCubit extends Cubit<TopProductState> {
  TopProductCubit() : super(TopProductInitial());

  Future<void> getTopProduct({required BuildContext context, int? subCategoryId, String? searchProductByName}) async {
    emit(TopProductLoading());
    await GetTopProductDataSource.getTopProduct(subCategoryId: subCategoryId, searchProductByName: searchProductByName).then(
      (value) async {
        value.fold((l) {
          emit(TopProductError(e: l.errMessage));
        }, (r) async {
          if (subCategoryId != null) {
            ConstantsModels.productsModel = r;
          } else if (searchProductByName != null) {
            ConstantsModels.searchProductsModel = r;
          } else {
            ConstantsModels.topProductModel = r;
          }
          log('Top Product: ${ConstantsModels.topProductModel?.data?.length}');

          emit(TopProductSuccess());
        });
      },
    );
  }
}
