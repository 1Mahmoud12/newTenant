import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_check_box.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_state.dart';
import 'package:dobzz_seller/feature/auth/signUp/view/presentation/add_password_view.dart';
import 'package:dobzz_seller/feature/auth/verifyCode/view/presentation/verify_code_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
            'set up your account'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
            textAlign: TextAlign.center,
          ),
          Text(
            'join us in just a few taps and manage your healthcare effortlessly'.tr(),
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
                  controller: AuthCubit.of(context).firstNameController,
                  hintText: 'first name'.tr(),
                  labelText: 'first name'.tr(),
                ),
                CustomTextFormField(
                  outPadding: EdgeInsets.zero,
                  controller: AuthCubit.of(context).lastNameController,
                  hintText: 'last name'.tr(),
                  labelText: 'last name'.tr(),
                ),
                CustomTextFormField(
                  outPadding: EdgeInsets.zero,
                  controller: AuthCubit.of(context).emailController,
                  hintText: 'enter your email'.tr(),
                  labelText: 'enter your email'.tr(),
                  textInputType: TextInputType.emailAddress,
                ),
                CustomCheckBox(
                  checkBox: checkBoxValue,
                  onTap: () {
                    checkBoxValue = !checkBoxValue;
                    if (checkBoxValue) {
                      AuthCubit.of(context).termAndCondition = 1;
                    }
                    setState(() {});
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: context.locale.languageCode == 'ar' ? 0 : 8.0, right: context.locale.languageCode == 'ar' ? 8.0 : 0),
                    child: Text.rich(
                      TextSpan(
                        text: 'agree with '.tr(),
                        style: Theme.of(context).textTheme.displayMedium,
                        children: [
                          TextSpan(
                            text: 'terms & condition'.tr(),
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                //context.navigateToPage(const TermsAndConditionsView());
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
              borderRadius: 8,
              childText: 'continue'.tr(),
              padding: const EdgeInsets.symmetric(vertical: 14.5),
              onPress: () {
                if (formKey.currentState!.validate()) {
                  context.navigateToPage(const AddPasswordView());
                }
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
