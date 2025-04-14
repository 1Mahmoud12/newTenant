import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCodeView extends StatefulWidget {
  final String phoneNumber;
  final int countryCodeId;

  final Function(BuildContext context)? verifyButton;
  final void Function(String)? onChanged;

  const VerifyCodeView({super.key, required this.phoneNumber, this.verifyButton, required this.countryCodeId, this.onChanged});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  late Timer _timer;
  int _start = 60; // Initialize the countdown value
  final FocusNode _focusNode = FocusNode();

  void startTimer() {
    _start = 60; // Reset to 60 seconds
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--; // Decrement the countdown value
        } else {
          _timer.cancel();
          // Restart the timer after the countdown reaches 0
          //  startTimer(); // Restart the timer by calling startTimer again
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    startTimer(); // Call this to start the timer initially
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the current timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'verify_phone_number'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'enter_the_verification_code_sent_to_your_phone_to_proceed_with_setting_a_new_password_'.tr(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.cB900),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 37),
            VerificationCode(
              focusNode: _focusNode,
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                } else {
                  AuthCubit.of(context).setCodeController(value);
                  log('Code ${AuthCubit.of(context).codeController.text}');
                }
              },
              onCompleted: (value) {
                widget.verifyButton?.call(context);
                //registerBloc?.verificationNumber = value;
                //registerBloc?.beforeRegisterSendCode(context);
              },
              validator: (p0) {
                return 'incorrect_otp._try_again';
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '00:${_start.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.cB100.withOpacity(.4)),
                ),
                InkWell(
                  onTap: _start != 0
                      ? null
                      : () {
                          AuthCubit.of(context).resendCode(context: context);
                          _timer.cancel();
                          startTimer();
                        },
                  child: Text(
                    'resend_code'.tr(),
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          color: _start != 0 ? AppColors.cB100.withOpacity(.4) : AppColors.primaryColor,
                          decorationColor: _start != 0 ? AppColors.cB100.withOpacity(.4) : AppColors.black,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) => CustomTextButton(
                childText: 'verify'.tr(),
                padding: const EdgeInsets.symmetric(vertical: 14.5),
                state: state is AuthResendCodeLoadingState,
                onPress: () {
                  widget.verifyButton?.call(context);

                  //  registerBloc?.beforeRegisterSendCode(context);
                  /*if (RegisterBloc.get(context).verificationNumber.round().toString() == newValue) {
                        context.navigateToPageWithClearStack(resetPassword ? const ResetPassword() : const CreatePassword());
                      } else {
                        Utils.showToast(title: 'Invalid Code', state: UtilState.error);
                      }*/
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerificationCode extends StatelessWidget {
  final void Function(String value)? onChanged;
  final void Function(String)? onCompleted;
  final String Function(String?)? validator;
  final FocusNode focusNode;
  const VerificationCode({super.key, this.onChanged, this.onCompleted, required this.focusNode, this.validator});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        length: 4,
        animationType: AnimationType.fade,
        animationDuration: const Duration(milliseconds: 300),
        appContext: context,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!.call(value);
          }
        },
        onCompleted: (value) {
          if (onCompleted != null) {
            onCompleted!.call(value);
          }
        },
        validator: (value) {
          return validator?.call(value);
        },
        textStyle: Theme.of(context).textTheme.titleSmall,
        hintStyle: Theme.of(context).textTheme.titleSmall,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(20),
          errorBorderColor: AppColors.cBorderPinColor,
          selectedColor: AppColors.primaryColor,
          selectedFillColor: AppColors.cBorderTextFormField,
          inactiveColor: AppColors.cBorderPinColor.withOpacity(.15),
          activeColor: AppColors.cB200,
          fieldWidth: context.screenWidth * .2,
          fieldHeight: context.screenWidth * .17,
        ),
        // hintCharacter: '-',
      ),
    );
  }
}
