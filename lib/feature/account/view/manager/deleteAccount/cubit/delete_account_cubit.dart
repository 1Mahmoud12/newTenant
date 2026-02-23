import 'package:bloc/bloc.dart';
import 'package:rova_star/core/network/local/cache.dart';
import 'package:rova_star/core/utils/navigate.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/account/data/dataSoruce/delete_account_data_source.dart';
import 'package:rova_star/feature/auth/login/view/presentation/login_screen.dart';
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
