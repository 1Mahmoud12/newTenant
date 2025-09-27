import 'dart:async';

import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Shows a modal bottom sheet for entering a 6-digit OTP verification code
///
/// [onSubmit] is called when the user submits a valid OTP code
/// [onResendCode] is called when the user requests to resend the code
/// [phoneNumber] is displayed to show which number received the code
/// [initialOtpValue] can be provided to pre-fill the OTP field
Future<void> showOtpVerificationBottomSheet({
  required BuildContext context,
  required Function(String otpCode) onSubmit,
  required Function() onResendCode,
  required String phoneNumber,
  String? initialOtpValue,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.scaffoldBackGround,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: OtpVerificationContent(
        onSubmit: onSubmit,
        onResendCode: onResendCode,
        phoneNumber: phoneNumber,
        initialOtpValue: initialOtpValue,
      ),
    ),
  );
}

class OtpVerificationContent extends StatefulWidget {
  final Function(String otpCode) onSubmit;
  final Function() onResendCode;
  final String phoneNumber;
  final String? initialOtpValue;

  const OtpVerificationContent({
    super.key,
    required this.onSubmit,
    required this.onResendCode,
    required this.phoneNumber,
    this.initialOtpValue,
  });

  @override
  State<OtpVerificationContent> createState() => _OtpVerificationContentState();
}

class _OtpVerificationContentState extends State<OtpVerificationContent> {
  late TextEditingController _otpController;
  late Timer _timer;
  int _start = 60;
  final FocusNode _focusNode = FocusNode();
  bool _isOtpComplete = false;

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
    _otpController = TextEditingController(text: widget.initialOtpValue);
    _focusNode.requestFocus();
    startTimer();

    // Check if the initial value is complete
    if (widget.initialOtpValue != null && widget.initialOtpValue!.length == 6) {
      _isOtpComplete = true;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _focusNode.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Verification Code'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Enter the 6-digit code sent to'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            widget.phoneNumber,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
          ),
          const SizedBox(height: 24),
          Directionality(
            textDirection: TextDirection.ltr,
            child: PinCodeTextField(
              autoDisposeControllers: false,
              length: 6,
              // 6-digit OTP
              animationType: AnimationType.fade,
              animationDuration: const Duration(milliseconds: 300),
              appContext: context,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              controller: _otpController,
              onChanged: (value) {
                setState(() {
                  _isOtpComplete = value.length == 6;
                });
              },
              onCompleted: (value) {
                // No auto-submission, let user press the button
                setState(() {
                  _isOtpComplete = true;
                });
                widget.onSubmit(value);
              },
              textStyle: Theme.of(context).textTheme.titleMedium,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                errorBorderColor: AppColors.cBorderPinColor,
                selectedColor: AppColors.primaryColor,
                selectedFillColor: AppColors.cBorderTextFormField,
                inactiveColor: AppColors.cBorderPinColor.withOpacityNew(.15),
                activeColor: AppColors.primaryColor,
                fieldWidth: 40,
                fieldHeight: 50,
              ),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
          const SizedBox(height: 16),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       '00:${_start.toString().padLeft(2, '0')}',
          //       style: Theme.of(context).textTheme.titleSmall?.copyWith(
          //             color: AppColors.primaryColor.withOpacityNew(.4),
          //           ),
          //     ),
          //     InkWell(
          //       onTap: _start != 0
          //           ? null
          //           : () {
          //               widget.onResendCode();
          //               _timer.cancel();
          //               startTimer();
          //             },
          //       child: Text(
          //         'Resend Code'.tr(),
          //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //               fontWeight: FontWeight.w700,
          //               decoration: TextDecoration.underline,
          //               color: _start != 0 ? AppColors.primaryColor.withOpacityNew(.4) : AppColors.primaryColor,
          //               decorationColor: _start != 0 ? AppColors.primaryColor.withOpacityNew(.4) : Colors.black,
          //             ),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: _isOtpComplete ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacityNew(0.5),
                foregroundColor: Colors.white,
              ),
              onPressed: _isOtpComplete
                  ? () {
                      widget.onSubmit(_otpController.text);
                      Navigator.pop(context);
                    }
                  : null,
              child: Text('Verify'.tr()),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
