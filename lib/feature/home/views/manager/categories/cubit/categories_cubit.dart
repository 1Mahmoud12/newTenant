import 'package:bloc/bloc.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/feature/home/data/dataSource/categories_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());
  static CategoriesCubit of(BuildContext context) => BlocProvider.of<CategoriesCubit>(context);
  Future<void> getCategories({required BuildContext context}) async {
    if (isClosed) return;
    emit(CategoriesLoading());
    await CategoriesDataSource.getCategories().then(
      (value) async {
        value.fold((l) {
          emit(CategoriesError(e: l.errMessage));
        }, (r) async {
          //   logger.i(r.toJson());
          ConstantsModels.categoriesModel = r;
          //log('Top Product: ${ConstantsModels.topProductModel?.data?.length}');
          if (isClosed) return;
          emit(CategoriesSuccess());
        });
      },
    );
  }
}
