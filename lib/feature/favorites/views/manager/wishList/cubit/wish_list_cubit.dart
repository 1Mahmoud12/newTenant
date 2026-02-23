import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/core/utils/custom_show_toast.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/favorites/data/dataSource/wish_list_data_source.dart';
import 'package:rova_star/feature/favorites/data/model/wish_list_model.dart';
import 'package:rova_star/feature/home/data/dataSource/add_to_wish_list_data_source.dart';
import 'package:rova_star/feature/home/data/dataSource/remove_from_whish_list_data_source.dart';
import 'package:rova_star/feature/home/data/models/product_mdoel.dart';

part 'wish_list_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListInitial());

  static WishListCubit get(BuildContext context) => BlocProvider.of(context);
  List<ItemWishModel> wishList = [];

  // Helper method to create a temporary wishlist item from product data
  ItemWishModel _createTempWishListItem({
    required Product product,
    required String skuCode,
  }) {
    return ItemWishModel(
      product: product.name,
      skuCode: skuCode,
      productId: product.id,
      priceForProduct: product.price,
      descriptionProduct: product.description,
      priceForProductOld: product.priceOld,
      productImagePath: product.imagePath,
      productThumbnailPath: product.thumbnailPath,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  Future<void> getWishList({required BuildContext context}) async {
    emit(WishListLoading());
    await WishListDataSource.getWishList().then(
      (value) async {
        value.fold((l) {
          emit(WishListError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          wishList = r.data ?? [];
          ConstantsModels.wishListModel = r;
          emit(WishListSuccess());
        });
      },
    );
  }

  bool isWishListed({required String skuCode}) {
    return wishList.any((element) => element.skuCode == skuCode);
  }

  Future<void> addToWishList({
    required BuildContext context,
    required String skuCode,
    Product? product,
  }) async {
    if (isClosed) return;

    // Check if already in wishlist
    if (isWishListed(skuCode: skuCode)) {
      return;
    }

    // Optimistically add to wishlist immediately
    if (product != null) {
      final tempItem = _createTempWishListItem(
        product: product,
        skuCode: skuCode,
      );
      wishList.add(tempItem);
      emit(WishListSuccess()); // Emit success to update UI immediately
    }

    // Make API call
    await AddToWishListDataSource.addToWishList(skuCode: skuCode).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;

          // Remove the optimistically added item on error
          if (product != null) {
            wishList.removeWhere((item) => item.productId == product.id && item.skuCode == skuCode);
            emit(WishListSuccess()); // Update UI
          }

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

  Future<void> removeFromWishList({required BuildContext context, required String skuCode}) async {
    if (isClosed) return;

    // Find the item to remove
    final itemToRemove = wishList.firstWhere(
      (element) => element.skuCode == skuCode,
      orElse: () => ItemWishModel(),
    );

    if (itemToRemove.id == null) {
      customShowToast(context, 'item_not_found');
      return;
    }

    // Optimistically remove from wishlist immediately
    final originalItem = itemToRemove;
    wishList.removeWhere((element) => element.skuCode == skuCode);
    emit(WishListSuccess()); // Update UI immediately

    // Make API call
    await RemoveFrommWishListDataSource.removeFromWishList(productId: originalItem.id!.toInt()).then(
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
          //  Utils.showToast(title: 'product remove form wish list successfully', state: UtilState.success);
          emit(RemoveFromWishListSuccess());
        });
      },
    );
  }
}
