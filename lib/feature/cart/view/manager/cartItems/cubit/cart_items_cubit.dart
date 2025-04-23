import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/cart/data/dataSource/cart_item_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'cart_items_state.dart';

class CartItemsCubit extends Cubit<CartItemsState> {
  CartItemsCubit() : super(CartItemsInitial());

  Future<void> getCartItems({required BuildContext context}) async {
    emit(CartItemsLoading());
    await CartItemDataSource.getCartItems().then(
      (value) async {
        value.fold((l) {
          emit(CartItemsError(e: l.errMessage));
        }, (r) async {
          log('cart items: ${r.data?.length}');
          ConstantsModels.cartItemModel = r;
          log('Cart items list: ${ConstantsModels.cartItemModel?.data?.length}');

          emit(CartItemsSuccess());
        });
      },
    );
  }
}
