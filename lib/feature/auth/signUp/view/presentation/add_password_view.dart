import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
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
  State<AddPasswordView> createState() => AddPasswordViewState();
}

class AddPasswordViewState extends State<AddPasswordView> {
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
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryColor),
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
            'protect your account'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
            textAlign: TextAlign.center,
          ),
          Text(
            'set a secure password for safe access'.tr(),
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
                  helperText: 'enter your password'.tr(),
                  hintText: 'password'.tr(),
                  labelText: 'password'.tr(),
                  password: true,
                ),
                CustomTextFormField(
                  outPadding: EdgeInsets.zero,
                  controller: AuthCubit.of(context).confirmPasswordController,
                  hintText: 're-password'.tr(),
                  labelText: 're-enter password'.tr(),
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
                    email: AuthCubit.of(context).emailController.text,
                    // phoneNumber: AuthCubit.of(context).phoneController.text,
                    // countryCodeId: AuthCubit.of(context).countryCodeId,
                    // verifyButton: (context) {
                    //   AuthCubit.of(context).verifyCode(context);
                    // },
                  ),
                );
              }
            },
            builder: (context, state) => CustomTextButton(
              childText: 'finish'.tr(),
              padding: const EdgeInsets.symmetric(vertical: 14.5),
              onPress: () {
                if (formKey.currentState!.validate()) {
                  if (AuthCubit.of(context).passwordController.text != AuthCubit.of(context).confirmPasswordController.text) {
                    customShowToast(context, 'passwords do not match'.tr(), showToastStatus: ShowToastStatus.error);
                  } else if (AuthCubit.of(context).termAndCondition == 0) {
                    customShowToast(context, 'you must agree with the terms & condition'.tr(), showToastStatus: ShowToastStatus.error);
                  } else {
                    //  context.navigateToPage(const NavigationView());
                    AuthCubit.of(context).signUp(context);
                  }
                }
              },
              // child: state is AuthSignUpLoadingState ? const LoadingWidget() : null,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
