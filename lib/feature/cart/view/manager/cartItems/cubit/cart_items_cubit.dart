import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/cart/data/dataSource/cart_item_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'cart_items_state.dart';

class CartItemsCubit extends Cubit<CartItemsState> {
  CartItemsCubit() : super(CartItemsInitial());
  static CartItemsCubit of(BuildContext context) => BlocProvider.of<CartItemsCubit>(context);
  Future<void> getCartItems({required BuildContext context}) async {
    if (isClosed) return;
    emit(CartItemsLoading());
    await CartItemDataSource.getCartItems().then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;
          emit(CartItemsError(e: l.errMessage));
        }, (r) async {
          log('cart items: ${r.data?.length}');
          ConstantsModels.cartItemModel = r;
          Constants.cartItems = r.data?.length ?? 0;
          log('Cart items list: ${ConstantsModels.cartItemModel?.data?.length}');
          if (isClosed) return;
          emit(CartItemsSuccess());
        });
      },
    );
  }

  void addCartItems() {
    Constants.cartItems++;
    if (isClosed) return;
    emit(UpdateCartItems());
  }

  void removeCartItems() {
    Constants.cartItems--;
    if (isClosed) return;
    emit(UpdateCartItems());
  }
}
