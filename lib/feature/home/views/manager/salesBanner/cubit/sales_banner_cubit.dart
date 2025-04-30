import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/home/data/dataSource/sales_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sales_banner_state.dart';

class SalesBannerCubit extends Cubit<SalesBannerState> {
  SalesBannerCubit() : super(SalesBannerInitial());
  Future<void> getSaleBanner({required BuildContext context}) async {
    emit(SalesBannerLoading());if (isClosed) return;
    await SalesDataSource.getSalesBanner().then(
      (value) async {
        value.fold((l) {if (isClosed) return;
          emit(SalesBannerError(e: l.errMessage));
        }, (r) async {if (isClosed) return;
          ConstantsModels.salesBannerModel = r;
          emit(SalesBannerSuccess());
        });
      },
    );
  }
}
