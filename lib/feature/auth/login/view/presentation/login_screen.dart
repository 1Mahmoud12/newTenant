import 'dart:developer';

import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/phone_number_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_images.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/forgetPassword/view/presentation/forget_password_view.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_state.dart';
import 'package:dobzz_seller/feature/auth/signUp/view/presentation/sign_up_view.dart';
import 'package:dobzz_seller/feature/auth/widgets/authRich_text_link.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    AuthCubit.of(context).phoneController.clear();
    AuthCubit.of(context).passwordController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   // actions: [
      //   //   InkWell(
      //   //     onTap: () {},
      //   //     child: Padding(
      //   //       padding: const EdgeInsets.symmetric(horizontal: 12),
      //   //       child: Container(
      //   //         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      //   //         decoration: BoxDecoration(
      //   //           border: Border.all(color: AppColors.cB700.withOpacityNew(.05), width: 2),
      //   //           borderRadius: BorderRadius.circular(40),
      //   //         ),
      //   //         child: Text(
      //   //           'sing up'.tr(),
      //   //           style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryColor),
      //   //         ),
      //   //       ),
      //   //     ),
      //   //   ),
      //   // ],
      // ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset(
                  AppImages.appLogo,
                  height: 60,
                  width: 130,
                  // fit: BoxFit.contain,
                ),
                //   const SizedBox(height: 20),
                Text(
                  'Login to your account'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black),
                ),
                const SizedBox(height: 10),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      PhoneNumberField(
                        outPadding: EdgeInsets.zero,
                        controller: AuthCubit.of(context).loginPhoneController,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) => CustomTextFormField(
                                outPadding: EdgeInsets.zero,
                                controller: AuthCubit.of(context).loginPasswordController,
                                validator: (value) {
                                  if (value.isEmpty) return 'required password'.tr();
                                  if (AuthCubit.of(context).errorMessage != null) return AuthCubit.of(context).errorMessage;
                                },
                                hintText: 'password'.tr(),
                                labelText: 'password'.tr(),
                                password: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => context.navigateToPage(const ForgetPasswordView()),
                      child: Text(
                        'forget password?'.tr(),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                              decorationColor: AppColors.primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoginSuccessState) {
                      context.navigateToPage(const NavigationViewWithThemes());
                    }
                    if (state is AuthLoginErrorState) {
                      log('current State is $state');

                      setState(() {
                        formKey.currentState!.validate();
                      });
                    }
                  },
                  builder: (context, state) => Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextButton(
                          borderRadius: 8,
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14.5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'log in'.tr(),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          onPress: () {
                            AuthCubit.of(context).errorMessage = null;
                            if (formKey.currentState!.validate()) {
                              //context.navigateToPage(const NavigationView());

                              AuthCubit.of(context).login(context);
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextButton(
                          borderRadius: 8,
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14.5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'guest'.tr(),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          onPress: () {
                            AuthCubit.of(context).countryCode = '+966';
                            AuthCubit.of(context).loginPhoneController.text = '500975853';
                            AuthCubit.of(context).loginPasswordController.text = '+966500975853';
                            AuthCubit.of(context).login(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AuthRichTextLink(
                  isCentered: true,
                  text: "Don't have an account? ".tr(),
                  linkText: 'Create account'.tr(),
                  onTap: () {
                    context.navigateToPage(const SignUpView());
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
