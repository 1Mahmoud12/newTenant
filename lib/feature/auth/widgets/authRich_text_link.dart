import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthRichTextLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;
  final bool isCentered;

  const AuthRichTextLink({
    Key? key,
    required this.text,
    required this.linkText,
    required this.onTap,
    this.isCentered = false, // Default not centered
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget richText = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Cairo',
          color: Colors.black.withOpacityNew(0.6),
          fontSize: Constants.tablet ? 16 : 16.sp,
        ),
        children: [
          TextSpan(
            text: linkText,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );

    return isCentered ? Center(child: richText) : richText;
  }
}
