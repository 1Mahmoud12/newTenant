import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/remove_from_whish_list_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'remove_from_whish_list_state.dart';

class RemoveFromWhishListCubit extends Cubit<RemoveFromWhishListState> {
  RemoveFromWhishListCubit() : super(RemoveFromWhishListInitial());

  Future<void> removeFromWishList({required BuildContext context, required int productId}) async {
    emit(RemoveFromWhishListLoading());
    await RemoveFromWhishListDataSource.removeFromWishList(productId: productId).then(
      (value) async {
        value.fold((l) {
          emit(RemoveFromWhishListError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          //  Utils.showToast(title: 'product remove form wish list successfully', state: UtilState.success);
          emit(RemoveFromWhishListSuccess());
        });
      },
    );
  }
}
