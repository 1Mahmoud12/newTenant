import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/cart/data/dataSource/add_to_cart_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'add_to_cart_state.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  AddToCartCubit() : super(AddToCartInitial());
  int quantity = 1;

  Future<void> addToCart({required BuildContext context, required int productId, String? sizeCode}) async {
    emit(AddToCartLoading());
    await AddToCartDataSource.addToCart(productId: productId, quantity: quantity, sizeCode: sizeCode).then(
      (value) async {
        value.fold((l) {
          emit(AddToCartError(e: l.errMessage));
        }, (r) async {
          //  Utils.showToast(title: 'Product Add to cart successfully', state: UtilState.success);
          //
          // context.navigateToPage(
          //   const CartView(),
          // );
          emit(AddToCartSuccess());
        });
      },
    );
  }

  Future<void> updateCartItem({required BuildContext context, required int cartItemId, required int quantity}) async {
    emit(AddToCartLoading());
    await AddToCartDataSource.updateCartItem(cartItemId: cartItemId, quantity: quantity).then(
      (value) async {
        value.fold(
          (l) {
            Utils.showToast(title: l.errMessage, state: UtilState.error);
          },
          (r) async {},
        );
      },
    );
  }
}
