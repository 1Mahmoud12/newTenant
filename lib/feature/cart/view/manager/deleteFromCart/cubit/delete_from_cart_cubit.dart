import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/feature/cart/data/dataSource/delete_form_cart_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'delete_from_cart_state.dart';

class DeleteFromCartCubit extends Cubit<DeleteFromCartState> {
  DeleteFromCartCubit() : super(DeleteFromCartInitial());

  Future<void> deleteFromCart({required BuildContext context, required int itemId}) async {
    if (isClosed) return;
    emit(DeleteFromCartLoading());
    await DeleteFromCart.deleteFromCart(itemId: itemId).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;
          emit(DeleteFromCartError(e: l.errMessage));
        }, (r) async {
          // log('Cart items list: ${ConstantsModels.cartItemModel?.data?.length}');
          if (isClosed) return;
          emit(DeleteFromCartSuccess());
        });
      },
    );
  }
}
