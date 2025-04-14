import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/bottomSheet/success_bottom_sheet.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44.0),
              child: Column(
                children: [
                  Text(
                    'reset_your_password'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'choose_a_new_password_to_regain_access.'.tr(),
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
                    controller: AuthCubit.of(context).passwordController,
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
                    controller: AuthCubit.of(context).confirmPasswordController,
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
                  successModalBottomSheet(
                    context,
                    title: 'password_updated_successfully'.tr(),
                    nameButton: 'login'.tr(),
                    onPress: () {
                      context.navigateToPageWithReplacement(const LoginScreen());
                    },
                  );
                }
              },
              builder: (context, state) => CustomTextButton(
                childText: 'create_new_password'.tr(),
                padding: const EdgeInsets.symmetric(vertical: 14.5),
                onPress: () {
                  AuthCubit.of(context).resetPassword(context);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
