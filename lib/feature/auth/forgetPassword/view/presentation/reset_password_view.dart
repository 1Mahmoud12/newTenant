import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_state.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(actions: const SizedBox(), context: context, title: 'Rest Password'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Reset Your Password'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Choose a new password to regain access.'.tr(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.cSecondaryBlack),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      outPadding: EdgeInsets.zero,
                      controller: AuthCubit.of(context).resetPasswordController,
                      validator: (value) {
                        if (value == null) return 'wrong_password,_please_try_again'.tr();
                      },
                      helperText: 'enter_your_password'.tr(),
                      hintText: 'password'.tr(),
                      labelText: 'password'.tr(),
                      password: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      outPadding: EdgeInsets.zero,
                      controller: AuthCubit.of(context).resetConfirmationPasswordController,
                      validator: (value) {
                        if (value == null) return 'wrong_password,_please_try_again'.tr();
                      },
                      helperText: 'enter_your_password'.tr(),
                      hintText: 're-password'.tr(),
                      labelText: 're-enter_password'.tr(),
                      password: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthResetPasswordSuccessState) {
                    context.navigateToPageWithClearStack(const LoginScreen());
                  }
                },
                builder: (context, state) => CustomTextButton(
                  childText: 'create_new_password'.tr(),
                  padding: const EdgeInsets.symmetric(vertical: 14.5),
                  onPress: () {
                    if (userCacheValue?.data?.phone != Constants.demoAccount) {
                      AuthCubit.of(context).resetPassword(context);
                    } else {
                      Utils.showToast(title: 'This is demo account you can not reset password', state: UtilState.error);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
