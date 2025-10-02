import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/account/data/dataSoruce/delete_account_data_source.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:flutter/material.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  Future<void> deleteAccount({required BuildContext context}) async {
    await DeleteAccountDataSource.deleteAccount().then(
      (value) async {
        value.fold((l) {}, (r) async {
          loginCacheValue = null;
          await loginCache?.clear();
          context.navigateToPageWithClearStack(const LoginScreen());
          Utils.showToast(title: 'Account Deleted Successfully', state: UtilState.success);
        });
      },
    );
  }
}
