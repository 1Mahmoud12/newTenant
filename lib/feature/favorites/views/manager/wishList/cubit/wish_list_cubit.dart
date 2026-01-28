import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/custom_show_toast.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/favorites/data/dataSource/wish_list_data_source.dart';
import 'package:dobzz_seller/feature/favorites/data/model/wish_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wish_list_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListInitial());

  static WishListCubit get(BuildContext context) => BlocProvider.of(context);
  List<ItemWishModel> wishList = [];

  Future<void> getWishList({required BuildContext context}) async {
    emit(WishListLoading());
    await WishListDataSource.getWishList().then(
      (value) async {
        value.fold((l) {
          emit(WishListError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          wishList = r.data?.data ?? [];
          ConstantsModels.wishListModel = r;
          emit(WishListSuccess());
        });
      },
    );
  }

  bool isWishListed({required int productId}) {
    return wishList.any((element) {
      return element.productId == productId;
    });
  }

  // Helper method for backward compatibility with skuCode
  // bool isWishListedBySkuCode({required int productId}) {
  //   return wishList.any((element) => element.productId == productId);
  // }

  Future<void> addToWishList({
    required BuildContext context,
    required int productId,
  }) async {
    if (isClosed) return;

    // Check if already in wishlist by product ID
    if (isWishListed(productId: productId)) {
      return;
    }

    // Make API call with new endpoint
    await WishListDataSource.toggleWishList(
      productId: productId,
      wishlistType: 'add',
    ).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;

          emit(AddToWishListError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          if (isClosed) return;

          // Refresh wishlist to get the complete model from server
          await getWishList(context: context);
          emit(AddToWishListSuccess());
        });
      },
    );
  }

  Future<void> removeFromWishList({
    required BuildContext context,
    required int productId,
  }) async {
    if (isClosed) return;

    // Find the item to remove
    final itemToRemove = wishList.firstWhere(
      (element) => element.productId == productId,
      orElse: () => ItemWishModel(),
    );

    if (itemToRemove.productId == null) {
      customShowToast(context, 'item_not_found');
      return;
    }

    // Optimistically remove from wishlist immediately
    final originalItem = itemToRemove;
    wishList.removeWhere((element) => element.productId == productId);
    emit(WishListSuccess()); // Update UI immediately

    // Make API call with new endpoint
    await WishListDataSource.toggleWishList(
      productId: productId,
      wishlistType: 'remove',
    ).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;

          // Re-add the item on error
          wishList.add(originalItem);
          emit(WishListSuccess()); // Update UI

          emit(RemoveFromWishListError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          if (isClosed) return;
          emit(RemoveFromWishListSuccess());
        });
      },
    );
  }
}
