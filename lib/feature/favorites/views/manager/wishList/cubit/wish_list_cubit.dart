import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/favorites/data/dataSource/wish_list_data_source.dart';
import 'package:dobzz_seller/feature/favorites/data/model/wish_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wish_list_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListInitial());

  static WishListCubit get(BuildContext context) => BlocProvider.of(context);
  List<ItemWishModel> wishList = [];
  Future<void> getWishList({required BuildContext context}) async {
    emit(WishListLoading());
    await WishListDataSource.getWishList().then(
      (value) async {
        value.fold((l) {
          emit(WishListError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          wishList = r.data ?? [];
          ConstantsModels.wishListModel = r;
          emit(WishListSuccess());
        });
      },
    );
  }
}
