import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/add_to_wish_list_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'add_to_wish_list_state.dart';

class AddToWishListCubit extends Cubit<AddToWishListState> {
  AddToWishListCubit() : super(AddToWishListInitial());

  Future<void> addToWishList({required BuildContext context, required int productId}) async {
    emit(AddToWishListLoading());
    await AddToWishListDataSource.addToWishList(productId: productId).then(
      (value) async {
        value.fold((l) {
          emit(AddToWishListError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          //  Utils.showToast(title: 'product add to wish list successfully', state: UtilState.success);
          emit(AddToWishListSuccess());
        });
      },
    );
  }
}
