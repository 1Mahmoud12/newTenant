import 'dart:developer';

import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/cart/data/dataSource/add_to_cart_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_to_cart_state.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  AddToCartCubit() : super(AddToCartInitial());
  int quantity = 1;

  Future<void> addToCart({required BuildContext context, required String sku, String? sizeCode, int? quantity}) async {
    if (isClosed) return;
    emit(AddToCartLoading());
    await AddToCartDataSource.addToCart(sku: sku, quantity: quantity ?? this.quantity, sizeCode: sizeCode).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;

          log('add to cart errors===> ${l.errMessage}');
          emit(AddToCartError(e: l.errMessage));
        }, (r) async {
          if (isClosed) return;
          //  Utils.showToast(title: 'Product Add to cart successfully', state: UtilState.success);
          //
          // context.navigateToPage(
          //   const CartView(),
          // );if (isClosed) return;
          emit(AddToCartSuccess());
        });
      },
    );
  }

  Future<void> updateCartItem({required BuildContext context, required int cartItemId, required int quantity}) async {
    if (isClosed) return;
    emit(AddToCartLoading());
    await AddToCartDataSource.updateCartItem(cartItemId: cartItemId, quantity: quantity).then(
      (value) async {
        value.fold(
          (l) {
            Utils.showToast(title: l.errMessage, state: UtilState.error);
            if (isClosed) return;
            emit(AddToCartError(e: l.errMessage));
          },
          (r) async {
            if (isClosed) return;
            emit(AddToCartSuccess());
          },
        );
      },
    );
  }
}
