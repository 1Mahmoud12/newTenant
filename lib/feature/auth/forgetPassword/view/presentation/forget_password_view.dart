import 'package:country_code_picker/country_code_picker.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/phone_number_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final ValueNotifier<CountryCode> _countryCodeNotifier;

  @override
  void initState() {
    _countryCodeNotifier = ValueNotifier(CountryCode.fromCountryCode('SA'));
    AuthCubit.of(context).phoneController.clear();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Text(
                  'forget password?'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'please enter your registered phone number to receive a one-time password (OTP).'.tr(),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.cB900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                PhoneNumberField(
                  controller: AuthCubit.of(context).phoneController,
                  outPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 32),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) => CustomTextButton(
                    backgroundColor: AppColors.primaryColor,
                    childText: 'continue'.tr(),
                    padding: const EdgeInsets.symmetric(vertical: 14.5),
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        AuthCubit.of(context).forgetPassword(context: context);
                      }
                      //context.navigateToPage(const VerifyCodeView());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
