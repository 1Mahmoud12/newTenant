import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rova_star/core/component/buttons/custom_text_button.dart';
import 'package:rova_star/core/component/phone_number_field.dart';
import 'package:rova_star/core/services/biometrics/biometric_service.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/app_icons.dart';
import 'package:rova_star/core/utils/app_images.dart';
import 'package:rova_star/core/utils/navigate.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:rova_star/feature/auth/manager/authBloc/auth_state.dart';
import 'package:rova_star/feature/auth/signUp/view/presentation/sign_up_view.dart';
import 'package:rova_star/feature/auth/widgets/authRich_text_link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final BiometricService _biometricService = BiometricService();
  bool _showBiometricButton = false;

  @override
  void initState() {
    super.initState();
    AuthCubit.of(context).phoneController.clear();
    //AuthCubit.of(context).passwordController.clear();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final isEnabled = await _biometricService.isBiometricEnabled();
    final isSupported = await _biometricService.isDeviceSupported();
    final canCheck = await _biometricService.canCheckBiometrics();

    if (mounted) {
      setState(() {
        _showBiometricButton = isEnabled && isSupported && canCheck;
      });
    }
  }

  Future<void> _handleBiometricLogin() async {
    final success = await _biometricService.attemptBiometricLogin(context);
    if (!success && mounted) {
      Utils.showToast(title: 'biometric_login_failed'.tr(), state: UtilState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  AppImages.appLogoWhite,
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
                      // const SizedBox(height: 16),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: BlocBuilder<AuthCubit, AuthState>(
                      //         builder: (context, state) => CustomTextFormField(
                      //           outPadding: EdgeInsets.zero,
                      //           controller: AuthCubit.of(context).loginPasswordController,
                      //           validator: (value) {
                      //             if (value.isEmpty) return 'required password'.tr();
                      //             if (AuthCubit.of(context).errorMessage != null) return AuthCubit.of(context).errorMessage;
                      //           },
                      //           hintText: 'password'.tr(),
                      //           labelText: 'password'.tr(),
                      //           password: true,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                // const SizedBox(height: 4),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     InkWell(
                //       onTap: () => context.navigateToPage(const ForgetPasswordView()),
                //       child: Text(
                //         'forget password?'.tr(),
                //         style: Theme.of(context).textTheme.displayMedium?.copyWith(
                //               fontWeight: FontWeight.w700,
                //               color: AppColors.primaryColor,
                //               decorationColor: AppColors.primaryColor,
                //               decoration: TextDecoration.underline,
                //             ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 16),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    // if (state is AuthLoginSuccessState) {
                    //   context.navigateToPage(const NavigationViewWithThemes());
                    // }
                    if (state is AuthLoginErrorState) {
                      log('current State is $state');

                      setState(() {
                        formKey.currentState!.validate();
                      });
                    }
                  },
                  builder: (context, state) => SizedBox(
                    height: 50.h,
                    child: Row(
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
                            onPress: () async {
                              AuthCubit.of(context).countryCode = '+966';
                              AuthCubit.of(context).loginPhoneController.text = '500975853';
                              AuthCubit.of(context).loginPasswordController.text = '+966500975853';

                              // Call login API
                              final loginSuccess = await AuthCubit.of(context).login(context);

                              // After successful login, automatically verify with code '1234'
                              if (loginSuccess && context.mounted) {
                                AuthCubit.of(context).otpController.text = '1234';
                                AuthCubit.of(context).verifyCode(context, isLogin: true);
                              }
                            },
                          ),
                        ),
                        if (_showBiometricButton) ...[
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomTextButton(
                              borderRadius: 8,
                              //  backgroundColor: AppColors.white,
                              // border: Border.all(color: AppColors.primaryColor, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14.5),
                              onPress: _handleBiometricLogin,
                              child: Platform.isIOS
                                  ? SvgPicture.asset(AppIcons.faceIdIc, height: 24, width: 24)
                                  : SvgPicture.asset(AppIcons.fingerPrintIc, height: 24, width: 24),
                            ),
                          ),
                        ],
                      ],
                    ),
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
