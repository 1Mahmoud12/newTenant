import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/themes/styles.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/screen_spaces_extension.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? nameField;
  final String? helperText;
  final bool? arabicLanguage;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? labelText;
  final bool? password;
  final int? maxLines;
  final TextInputType? textInputType;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? enabledBorder;
  final double? fontSizeHintText;
  final double? height;
  final double? width;
  final EdgeInsets? contentPadding;
  final EdgeInsets? outPadding;
  final double? borderRadius;
  final bool? validationOnNumber;
  final bool? enable;
  final Key? validateKey;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String value)? onChange;
  final Function? validator;
  final FocusNode? focusNode;
  final TextStyle? nameFieldStyle;
  final TextDirection? textDirection;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.password = false,
    this.maxLines,
    this.textInputType,
    this.fillColor,
    this.fontSizeHintText,
    this.focusedBorderColor,
    this.validationOnNumber,
    this.labelText,
    this.nameField,
    this.height,
    this.width,
    this.enable = true,
    this.enabledBorder,
    this.borderRadius,
    this.contentPadding,
    this.onChange,
    this.outPadding,
    this.validateKey,
    this.hintStyle,
    this.inputFormatters,
    this.validator,
    this.helperText,
    this.focusNode,
    this.arabicLanguage,
    this.nameFieldStyle,
    this.textDirection,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = false;

  @override
  void initState() {
    // TODO: implement initState
    _obscureText = widget.password!;

    super.initState();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool validateField(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ///You must add [[width]] in SizeBox before use it
    return Padding(
      padding: widget.outPadding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        // width: context.screenWidth * (widget.width ?? .9),
        // height: context.screenHeight * (widget.height ?? .13),
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(),
          shadows: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 35,
              offset: Offset(0, 9),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.nameField != null)
              Text(
                widget.nameField!.tr(),
                style: widget.nameFieldStyle ?? Styles.style14300,
              ),
            if (widget.nameField != null) 6.ESH(),
            TextFormField(
              obscureText: _obscureText,
              controller: widget.controller,
              keyboardType: widget.textInputType ?? TextInputType.text,
              style: TextStyle(
                color: AppColors.black,
                fontSize: Constants.tablet ? (widget.fontSizeHintText ?? 17) : (widget.fontSizeHintText ?? 17).sp,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (value) {
                if (widget.onChange != null) {
                  widget.onChange!.call(value);
                }
              },
              validator: widget.validator != null
                  ? (value) => widget.validator!(value)
                  : (value) {
                      if (!validateField(value!)) {
                        return 'This field is required'.tr();
                      }
                      return null;
                    },
              inputFormatters: widget.inputFormatters ??
                  [
                    if (widget.validationOnNumber != null && widget.validationOnNumber!) FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}$')),
                  ],
              maxLines: widget.maxLines ?? 1,
              cursorColor: AppColors.textColorTextFormField,
              focusNode: widget.focusNode,
              textDirection: widget.textDirection ?? (context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr),
              decoration: InputDecoration(
                alignLabelWithHint: true,
                errorStyle: TextStyle(color: AppColors.red, fontSize: 14, fontWeight: FontWeight.w500),
                enabled: widget.enable!,
                hintText: widget.hintText.tr(),
                hintStyle: widget.hintStyle ??
                    TextStyle(
                      color: AppColors.grey.withOpacityNew(.5),
                      fontSize: Constants.tablet ? (widget.fontSizeHintText ?? 17) : (widget.fontSizeHintText ?? 17).sp,
                      fontWeight: FontWeight.w500,
                    ),
                prefixIcon: widget.prefixIcon,
                labelText: widget.labelText?.tr(),
                labelStyle: TextStyle(
                  color: AppColors.primaryColor.withOpacityNew(.5),
                  fontSize: Constants.tablet ? (widget.fontSizeHintText ?? 17) : (widget.fontSizeHintText ?? 17).sp,
                  fontWeight: FontWeight.w600,
                ),
                fillColor: widget.fillColor ?? AppColors.white,
                hintTextDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                filled: true,
                helper: widget.helperText != null
                    ? Text(
                        widget.helperText ?? '',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.subTextColor),
                      )
                    : null,
                contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 8)),
                  borderSide: BorderSide(color: widget.enabledBorder ?? AppColors.grey.withOpacityNew(.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 8)),
                  borderSide: BorderSide(color: widget.focusedBorderColor ?? AppColors.primaryColor.withOpacityNew(.4)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 8)),
                  borderSide: BorderSide(color: widget.focusedBorderColor ?? AppColors.primaryColor.withOpacityNew(.4)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 8)),
                  borderSide: BorderSide(color: AppColors.red),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 8)),
                  borderSide: BorderSide(color: widget.focusedBorderColor ?? AppColors.black.withOpacityNew(.1)),
                ),
                suffixIcon: widget.password != null && widget.password!
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                          onTap: _toggle,
                          child: _obscureText
                              ? SvgPicture.asset(
                                  AppIcons.passwordShow,
                                  fit: BoxFit.cover,
                                )
                              : SvgPicture.asset(
                                  AppIcons.hidePassword,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      )
                    : widget.suffixIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
