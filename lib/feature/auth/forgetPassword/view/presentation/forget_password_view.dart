import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamlaka/core/component/buttons/custom_text_button.dart';
import 'package:mamlaka/core/themes/colors.dart';
import 'package:mamlaka/feature/auth/login/view/presentation/widgets/phone_number_widget.dart';
import 'package:mamlaka/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:mamlaka/feature/auth/manager/authBloc/auth_state.dart';

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
    super.initState();
  }

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
            const SizedBox(height: 50),
            Text(
              'forget_password?'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
              textAlign: TextAlign.center,
            ),
            Text(
              'please_enter_your_registered_phone_number_to_receive_a_one-time_password_(OTP).'.tr(),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.cB900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: PhonePickerField(
                    cubit: AuthCubit.of(context),
                    helperText: 'enter_your_phone_number'.tr(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) => CustomTextButton(
                backgroundColor: AppColors.primaryColor,
                childText: 'continue'.tr(),
                padding: const EdgeInsets.symmetric(vertical: 14.5),
                onPress: () {
                  AuthCubit.of(context).forgetPassword(context: context);
                },
                state: state is AuthGetCountryCodeLoadingState,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
