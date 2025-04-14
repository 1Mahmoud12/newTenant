import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/forgetPassword/view/presentation/forget_password_view.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/widgets/phone_number_widget.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_state.dart';
import 'package:dobzz_seller/feature/auth/signUp/view/presentation/sign_up_view.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              context.navigateToPage(const SignUpView());
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
                  'sing_up'.tr(),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.cB600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              "you're_back!".tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
            ),
            Text(
              'explore_available_services,_see_real-time_availability,_and_book_with_ease.'.tr(),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.cB900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        Expanded(
                          child: PhonePickerField(
                            helperText: 'enter_your_phone_number'.tr(),
                            cubit: AuthCubit.of(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) => CustomTextFormField(
                            outPadding: EdgeInsets.zero,
                            controller: AuthCubit.of(context).passwordController,
                            validator: (value) {
                              if (value.isEmpty) return 'required_password'.tr();
                              if (AuthCubit.of(context).errorMessage != null) return AuthCubit.of(context).errorMessage;
                            },
                            helperText: 'enter_your_password'.tr(),
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
                    'forget_password?'.tr(),
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
                  context.navigateToPage(const NavigationView());
                }
                if (state is AuthLoginErrorState) {
                  log('current State is $state');

                  setState(() {
                    formKey.currentState!.validate();
                  });
                }
              },
              builder: (context, state) => CustomTextButton(
                borderRadius: 78,
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14.5),
                child: state is AuthLoginLoadingState
                    ? const LoadingWidget()
                    : Row(
                        children: [
                          Expanded(
                            child: Text(
                              'log_in'.tr(),
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
                    AuthCubit.of(context).login(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
