import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/favorites/data/dataSource/wish_list_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'wish_list_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListInitial());
  Future<void> getWishList({required BuildContext context}) async {
    emit(WishListLoading());
    await WishListDataSource.getWishList().then(
      (value) async {
        value.fold((l) {
          emit(WishListError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          Utils.showToast(title: 'product add to wish list successfully', state: UtilState.success);
          emit(WishListSuccess());
        });
      },
    );
  }
}
