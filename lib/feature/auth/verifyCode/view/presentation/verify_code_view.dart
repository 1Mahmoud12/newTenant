import 'dart:async';

import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCodeView extends StatefulWidget {
  final Function(BuildContext context)? verifyButton;
  final void Function(String)? onChanged;
  final bool isForgetPassword;
  final bool isLogin;

  const VerifyCodeView({
    super.key,
    this.onChanged,
    this.verifyButton,
    required this.isForgetPassword,
    required this.isLogin,
  });

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  late Timer _timer;
  int _start = 60;
  final FocusNode _focusNode = FocusNode();

  void startTimer() {
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_start > 0) {
            _start--;
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    AuthCubit.of(context).otpController.clear();

    _focusNode.requestFocus();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'verify phone number'.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'enter the verification code sent to your phone to proceed with setting a new password'.tr(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.cB900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 37),
              VerificationCode(
                controller: AuthCubit.of(context).otpController,
                focusNode: _focusNode,
                onChanged: (value) {},
                onCompleted: (p0) {
                  AuthCubit.of(context).verifyCode(context, isForgetPassword: widget.isForgetPassword);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '00:${_start.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primaryColor.withOpacityNew(.4)),
                  ),
                  InkWell(
                    onTap: _start == 0
                        ? null
                        : () {
                            if (widget.isForgetPassword) {
                              AuthCubit.of(context).forgetPassword(context: context, navigateToVerifyCodeView: false);
                            } else {
                              AuthCubit.of(context).resendCode(context: context, isLogin: widget.isLogin);
                            }
                            _timer.cancel();
                            startTimer();
                          },
                    child: Text(
                      'resend code'.tr(),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            color: _start != 0 ? AppColors.primaryColor.withOpacityNew(.4) : AppColors.primaryColor,
                            decorationColor: _start != 0 ? AppColors.primaryColor.withOpacityNew(.4) : AppColors.black,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomTextButton(
                childText: 'verify'.tr(),
                padding: const EdgeInsets.symmetric(vertical: 14.5),
                onPress: () {
                  AuthCubit.of(context).verifyCode(context, isForgetPassword: widget.isForgetPassword);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationCode extends StatefulWidget {
  final void Function(String value)? onChanged;
  final void Function(String)? onCompleted;
  final String Function(String?)? validator;
  final FocusNode focusNode;
  const VerificationCode({super.key, this.onChanged, this.onCompleted, required this.focusNode, this.validator, this.controller});
  final TextEditingController? controller;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 60 - 32;
    final fieldWidth = (availableWidth / 4).clamp(40.0, 60.0);
    final fieldHeight = fieldWidth * 1.2;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        autoDisposeControllers: false,
        length: 4,
        animationType: AnimationType.fade,
        animationDuration: const Duration(milliseconds: 300),
        appContext: context,
        focusNode: widget.focusNode,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!.call(value);
          }
        },
        onCompleted: (value) {
          if (widget.onCompleted != null) {
            widget.onCompleted!.call(value);
          }
        },
        validator: (value) {
          return widget.validator?.call(value);
        },
        errorTextSpace: 32,
        controller: widget.controller,
        textStyle: Theme.of(context).textTheme.titleSmall,
        hintStyle: Theme.of(context).textTheme.titleSmall,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          errorBorderColor: AppColors.cBorderPinColor,
          selectedColor: AppColors.primaryColor,
          selectedFillColor: AppColors.cBorderTextFormField,
          inactiveColor: AppColors.cBorderPinColor.withOpacityNew(.15),
          activeColor: AppColors.primaryColor,
          fieldWidth: fieldWidth,
          fieldHeight: fieldHeight,
        ),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
