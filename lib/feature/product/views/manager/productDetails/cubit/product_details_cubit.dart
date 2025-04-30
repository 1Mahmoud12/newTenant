import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/product/data/dataSource/product_details_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  Future<void> getProductDetailsData({required BuildContext context, required int productId}) async {
    if (isClosed) return;
    emit(ProductDetailsLoading());
    await ProductDetailsDataSource.getProductDetails(productId: productId).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;
          emit(ProductDetailsError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.productDetailsModel = r;
          if (isClosed) return;
          // log('Cart items list: ${ConstantsModels.cartItemModel?.data?.length}');if (isClosed) return;
          emit(ProductDetailsSuccess());
        });
      },
    );
  }
}
