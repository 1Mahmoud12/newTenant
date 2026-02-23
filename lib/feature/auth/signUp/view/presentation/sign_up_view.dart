import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rova_star/core/component/buttons/custom_text_button.dart';
import 'package:rova_star/core/component/custom_check_box.dart';
import 'package:rova_star/core/component/fields/custom_text_form_field.dart';
import 'package:rova_star/core/component/phone_number_field.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/app_images.dart';
import 'package:rova_star/core/utils/extensions.dart';
import 'package:rova_star/core/utils/navigate.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/auth/login/view/presentation/login_screen.dart';
import 'package:rova_star/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:rova_star/feature/auth/manager/authBloc/auth_state.dart';
import 'package:rova_star/feature/auth/verifyCode/view/presentation/verify_code_view.dart';
import 'package:rova_star/feature/auth/widgets/authRich_text_link.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool checkBoxValue = false;
  late final AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    authCubit = AuthCubit.of(context);
    authCubit.nameController.clear();
    authCubit.phoneController.clear();
    // authCubit.passwordController.clear();
    // authCubit.confirmPasswordController.clear();
  }

  // @override
  // void dispose() {
  //   nameController.dispose();
  //   phoneController.dispose();
  //   passwordController.dispose();
  //   confirmPasswordController.dispose();
  //   super.dispose();
  // }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required'.tr();
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters'.tr();
    }
    return null;
  }

  // String? validateConfirmPassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Confirm password is required'.tr();
  //   }
  //   if (value != authCubit.passwordController.text) {
  //     return 'Passwords do not match'.tr();
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    AppImages.appLogoWhite,
                    height: 60,
                    width: 130,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Create an account'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.black,
                      ),
                ),
                const SizedBox(height: 10),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: authCubit.nameController,
                        hintText: 'Name'.tr(),
                        labelText: 'Name'.tr(),
                        outPadding: EdgeInsets.zero,
                      ),
                      PhoneNumberField(
                        controller: authCubit.phoneController,
                        outPadding: EdgeInsets.zero,
                      ),
                      // CustomTextFormField(
                      //   controller: authCubit.passwordController,
                      //   hintText: 'Password'.tr(),
                      //   labelText: 'Password'.tr(),
                      //   helperText: 'Enter your password'.tr(),
                      //   password: true,
                      //   validator: validatePassword,
                      //   outPadding: EdgeInsets.zero,
                      // ),
                      // CustomTextFormField(
                      //   controller: authCubit.confirmPasswordController,
                      //   hintText: 'Re-enter password'.tr(),
                      //   labelText: 'Re-enter password'.tr(),
                      //   password: true,
                      //   validator: validateConfirmPassword,
                      //   outPadding: EdgeInsets.zero,
                      // ),
                      CustomCheckBox(
                        checkBox: checkBoxValue,
                        onTap: () {
                          setState(() {
                            checkBoxValue = !checkBoxValue;
                            if (checkBoxValue) {
                              AuthCubit.of(context).termAndCondition = 1;
                            } else {
                              AuthCubit.of(context).termAndCondition = 0;
                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: context.locale.languageCode == 'ar' ? 0 : 8.0,
                            right: context.locale.languageCode == 'ar' ? 8.0 : 0,
                          ),
                          child: Text.rich(
                            TextSpan(
                              text: 'Agree with '.tr(),
                              style: Theme.of(context).textTheme.displayMedium,
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions'.tr(),
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to Terms and Conditions page if you want
                                      // context.navigateToPage(const TermsAndConditionsView());
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ].paddingDirectional(bottom: 16),
                  ),
                ),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSignUpSuccessState) {
                      context.navigateToPage(
                        const VerifyCodeView(
                          isForgetPassword: false,
                          isLogin: false,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomTextButton(
                      childText: 'Create an account'.tr(),
                      borderRadius: 8,
                      padding: const EdgeInsets.symmetric(vertical: 14.5),
                      onPress: () {
                        if (formKey.currentState?.validate() ?? false) {
                          if (AuthCubit.of(context).termAndCondition == 1) {
                            AuthCubit.of(context).signUp(context);
                          } else {
                            Utils.showToast(
                              title: 'Please accept the terms and conditions to continue'.tr(),
                              state: UtilState.error,
                            );
                          }
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                AuthRichTextLink(
                  isCentered: true,
                  text: 'Already have an account? '.tr(),
                  linkText: 'Login'.tr(),
                  onTap: () {
                    context.navigateToPageWithClearStack(const LoginScreen());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
