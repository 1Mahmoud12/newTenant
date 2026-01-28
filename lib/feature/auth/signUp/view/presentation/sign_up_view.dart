import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_check_box.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/phone_number_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_images.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_state.dart';
import 'package:dobzz_seller/feature/auth/widgets/authRich_text_link.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    // Defer controller operations until after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authCubit.nameController.clear();
      authCubit.emailController.clear();
      authCubit.passwordController.clear();
      authCubit.confirmPasswordController.clear();
    });
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_is_required'.tr();
    }

    // Regular expression for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'please_enter_valid_email'.tr();
    }

    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_is_required'.tr();
    }
    if (value.length < 6) {
      return 'password_must_be_at_least_6_characters'.tr();
    }
    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'confirm_password_is_required'.tr();
    }
    if (value != authCubit.passwordController.text) {
      return 'passwords_do_not_match'.tr();
    }
    return null;
  }

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
                    AppImages.appLogo,
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
                        outPadding: EdgeInsets.zero,
                        controller: authCubit.nameController,
                        nameField: 'Name'.tr(),
                        hintText: 'Enter your first name'.tr(),
                        textInputType: TextInputType.name,
                      ),
                      CustomTextFormField(
                        outPadding: EdgeInsets.zero,
                        controller: authCubit.emailController,
                        nameField: 'Email Address'.tr(),
                        hintText: 'Enter your email address'.tr(),
                        textInputType: TextInputType.emailAddress,
                        password: false,
                        validator: validateEmail,
                      ),
                      PhoneNumberField(
                        controller: authCubit.phoneController,
                        outPadding: EdgeInsets.zero,
                      ),
                      CustomTextFormField(
                        outPadding: EdgeInsets.zero,
                        controller: authCubit.passwordController,
                        nameField: 'Password'.tr(),
                        hintText: 'Enter your password'.tr(),
                        password: true,
                        validator: validatePassword,
                      ),
                      CustomTextFormField(
                        outPadding: EdgeInsets.zero,
                        controller: authCubit.confirmPasswordController,
                        nameField: 'Confirm Password'.tr(),
                        hintText: 'Re-enter password'.tr(),
                        password: true,
                        validator: validateConfirmPassword,
                      ),
                      CustomCheckBox(
                        checkBox: checkBoxValue,
                        onTap: () {
                          setState(() {
                            checkBoxValue = !checkBoxValue;
                            if (checkBoxValue) {
                              authCubit.termAndCondition = 1;
                            } else {
                              authCubit.termAndCondition = 0;
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(color: AppColors.primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to Terms and Conditions page
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
                      context.navigateToPage(const LoginScreen());
                    }
                  },
                  builder: (context, state) {
                    return CustomTextButton(
                      childText: 'Create an account'.tr(),
                      borderRadius: 8,
                      padding: const EdgeInsets.symmetric(vertical: 14.5),
                      onPress: () {
                        if (formKey.currentState?.validate() ?? false) {
                          if (checkBoxValue) {
                            authCubit.signUp(context);
                          } else {
                            Utils.showToast(
                              title: 'please_accept_terms_and_conditions'.tr(),
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
