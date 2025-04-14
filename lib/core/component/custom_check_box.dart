import 'package:flutter/material.dart';
import 'package:dobzz_seller/core/themes/styles.dart';
import 'package:dobzz_seller/core/utils/screen_spaces_extension.dart';

import '../themes/colors.dart';

class CustomCheckBox extends StatefulWidget {
  final bool borderEnable;
  final bool? checkBox;
  final void Function()? onTap;
  final double? paddingIcon;
  final double? sizeIcon;
  final double? borderRadius;
  final double? widthBorder;
  final Color? fillFalseValue;
  final Color? fillTrueValue;
  final Color? borderColor;
  final String? textValue;
  final Widget? child;

  const CustomCheckBox({
    super.key,
    this.borderEnable = true,
    this.fillFalseValue,
    this.sizeIcon,
    this.fillTrueValue,
    this.paddingIcon,
    this.borderColor,
    this.widthBorder,
    this.textValue,
    this.borderRadius,
    this.onTap,
    this.checkBox = false,
    this.child,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!.call();
        }
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(widget.paddingIcon ?? 3),
            width: widget.sizeIcon ?? 25,
            height: widget.sizeIcon ?? 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.checkBox! ? widget.fillTrueValue ?? AppColors.primaryColor : widget.fillFalseValue ?? AppColors.white,
              border: Border.all(
                color: widget.borderEnable ? widget.borderColor ?? AppColors.cBorderDecoration : AppColors.transparent,
                width: widget.widthBorder ?? 1,
              ),
            ),
            child: Icon(Icons.check, size: ((widget.sizeIcon) ?? 25) - 8, color: widget.checkBox! ? AppColors.white : AppColors.transparent),
          ),
          if (widget.textValue != null) 10.ESW(),
          Expanded(
            child: widget.child != null
                ? widget.child!
                : Text(
                    widget.textValue ?? '',
                    style: Styles.style12400.copyWith(color: AppColors.subTextColor),
                  ),
          ),
        ],
      ),
    );
  }
}
