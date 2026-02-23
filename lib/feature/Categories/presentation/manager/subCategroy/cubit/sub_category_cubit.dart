import 'package:bloc/bloc.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/Categories/data/dataSource/sub_categories_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sub_category_state.dart';

class SubCategoryCubit extends Cubit<SubCategoryState> {
  SubCategoryCubit() : super(SubCategoryInitial());

  Future<void> getSubCategories({required BuildContext context, required int categoryId}) async {
    emit(SubCategoryLoading());
    await SubCategoriesDataSource.getSubCategories(categoryId: categoryId).then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          emit(SubCategoryError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.subCategoryModel = r;
          emit(SubCategorySuccess());
        });
      },
    );
  }
}
