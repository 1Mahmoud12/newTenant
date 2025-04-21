import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/categories_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  Future<void> getCategories({required BuildContext context}) async {
    emit(CategoriesLoading());
    await CategoriesDataSource.getCategories().then(
      (value) async {
        value.fold((l) {
          emit(CategoriesError(e: l.errMessage));
        }, (r) async {
          //   logger.i(r.toJson());
          ConstantsModels.categoriesModel = r;
          //log('Top Product: ${ConstantsModels.topProductModel?.data?.length}');

          emit(CategoriesSuccess());
        });
      },
    );
  }
}
