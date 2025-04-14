import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/custom_show_toast.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_state.dart';
import 'package:dobzz_seller/feature/auth/verifyCode/view/presentation/verify_code_view.dart';

class AddPasswordView extends StatefulWidget {
  const AddPasswordView({super.key});

  @override
  State<AddPasswordView> createState() => _AddPasswordViewState();
}

class _AddPasswordViewState extends State<AddPasswordView> {
  bool checkBoxValue = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              context.navigateToPage(const LoginScreen());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.cB700.withOpacity(.05), width: 2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  'login'.tr(),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.cB800),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          const SizedBox(height: 32),
          Text(
            'protect_your_account'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
            textAlign: TextAlign.center,
          ),
          Text(
            'set_a_secure_password_for_safe_access'.tr(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.cB900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 26),
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  outPadding: EdgeInsets.zero,
                  controller: AuthCubit.of(context).passwordController,
                  // validator: (value) {
                  //   if (value == null) return 'wrong_password,_please_try_again'.tr();
                  // },
                  helperText: 'enter_your_password'.tr(),
                  hintText: 'password'.tr(),
                  labelText: 'password'.tr(),
                  password: true,
                ),
                CustomTextFormField(
                  outPadding: EdgeInsets.zero,
                  controller: AuthCubit.of(context).confirmPasswordController,
                  // validator: (value) {
                  //   if (value == null) {
                  //     return Text(
                  //       'wrong_password,_please_try_again'.tr(),
                  //       //  style: TextStyle(color: AppColors.red, fontSize: 14, fontWeight: FontWeight.w500),
                  //     );
                  //   }
                  // },
                  // helperText: 'enter_your_password'.tr(),
                  hintText: 're-password'.tr(),
                  labelText: 're-enter_password'.tr(),
                  password: true,
                ),
              ].paddingDirectional(bottom: 16),
            ),
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSignUpSuccessState) {
                context.navigateToPageWithReplacement(
                  VerifyCodeView(
                    phoneNumber: AuthCubit.of(context).phoneController.text,
                    countryCodeId: AuthCubit.of(context).countryCodeId,
                    verifyButton: (context) {
                      AuthCubit.of(context).verifyCode(context);
                    },
                  ),
                );
              }
            },
            builder: (context, state) => CustomTextButton(
              childText: state is AuthSignUpLoadingState ? null : 'finish'.tr(),
              padding: const EdgeInsets.symmetric(vertical: 14.5),
              onPress: () {
                if (formKey.currentState!.validate()) {
                  if (AuthCubit.of(context).passwordController.text != AuthCubit.of(context).confirmPasswordController.text) {
                    customShowToast(context, 'passwords_do_not_match'.tr(), showToastStatus: ShowToastStatus.error);
                  } else if (!checkBoxValue) {
                    customShowToast(context, 'you_must_agree_with_the_terms_&_condition'.tr(), showToastStatus: ShowToastStatus.error);
                  } else {
                    AuthCubit.of(context).signUp(context);
                  }
                }
              },
              child: state is AuthSignUpLoadingState ? const LoadingWidget() : null,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
