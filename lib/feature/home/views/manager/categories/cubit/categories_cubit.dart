import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/categories_data_source.dart';
import 'package:dobzz_seller/feature/home/data/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          ConstantsModels.categoriesModel = r;
          if (isClosed) return;
          emit(CategoriesSuccess(data: r.data ?? []));
        });
      },
    );
  }

  Future<void> getAllCategories() async {
    if (isClosed) return;
    emit(CategoriesLoading());
    await CategoriesDataSource.getCategories().then(
      (value) async {
        value.fold((l) {
          emit(CategoriesError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.categoriesModel = r;
          if (isClosed) return;
          emit(CategoriesSuccess(data: r.data ?? []));
        });
      },
    );
  }
}
