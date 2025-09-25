import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/custom_show_toast.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/remove_from_whish_list_data_source.dart';
import 'package:flutter/material.dart';

part 'remove_from_whish_list_state.dart';

class RemoveFrommWishListCubit extends Cubit<RemoveFromWhishListState> {
  RemoveFrommWishListCubit() : super(RemoveFromWhishListInitial());

  Future<void> removeFromWishList({required BuildContext context, required String skuCode}) async {
    if (isClosed) return;
    emit(RemoveFromWhishListLoading());
    final wishListId = WishListCubit.get(context).wishList.firstWhere((element) => element.skuCode == skuCode).id;
    if (wishListId != null) {
      await RemoveFrommWishListDataSource.removeFromWishList(productId: wishListId.toInt()).then(
        (value) async {
          value.fold((l) {
            if (isClosed) return;
            emit(RemoveFromWhishListError(e: l.errMessage));
            Utils.showToast(title: l.errMessage, state: UtilState.error);
          }, (r) async {
            if (isClosed) return;
            //  Utils.showToast(title: 'product remove form wish list successfully', state: UtilState.success);
            WishListCubit.get(context).getWishList(context: context);
            emit(RemoveFromWhishListSuccess());
          });
        },
      );
    } else {
      customShowToast(context, 'item_not_found');
    }
  }
}
