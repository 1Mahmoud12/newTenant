import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/add_to_wish_list_data_source.dart';
import 'package:flutter/material.dart';

part 'add_to_wish_list_state.dart';

class AddToWishListCubit extends Cubit<AddToWishListState> {
  AddToWishListCubit() : super(AddToWishListInitial());

  Future<void> addToWishList({required BuildContext context, required String skuCode}) async {
    if (isClosed) return;
    emit(AddToWishListLoading());
    await AddToWishListDataSource.addToWishList(skuCode: skuCode).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;
          emit(AddToWishListError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          if (isClosed) return;
          WishListCubit.get(context).getWishList(context: context);

          emit(AddToWishListSuccess());
        });
      },
    );
  }
}
