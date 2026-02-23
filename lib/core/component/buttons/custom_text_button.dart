import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rova_star/core/component/loadsErros/loading_widget.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/constants.dart';

class CustomTextButton extends StatefulWidget {
  final Widget? child;
  final String? childText;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? colorText;
  final void Function()? onPress;
  final double borderWidth;
  final double? height;
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool isExpanded;
  final bool state;
  final BorderRadiusGeometry? allBorderRadius;
  final Color? loadingColor;
  const CustomTextButton({
    super.key,
    this.child,
    required this.onPress,
    this.backgroundColor,
    this.borderWidth = 1,
    this.height,
    this.borderRadius,
    this.borderColor,
    this.padding,
    this.isExpanded = true,
    this.childText,
    this.colorText,
    this.allBorderRadius,
    this.gradient,
    this.state = false,
    this.loadingColor,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: widget.isExpanded ? 1 : 0,
          child: SizedBox(
            //width: context.screenWidth * (widget.width ?? .9),
            //   height: context.screenHeight * (widget.height ?? .06),
            child: InkWell(
              onTap: widget.onPress,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppColors.primaryColor,
                  border: Border.all(color: widget.borderColor ?? AppColors.transparent, width: widget.borderWidth),
                  borderRadius: widget.allBorderRadius ?? BorderRadius.circular((widget.borderRadius ?? 8).r),
                  gradient: widget.gradient,
                ),
                // alignment: Alignment.center,
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.all(12),
                  child: widget.state
                      ? Center(
                          child: LoadingWidget(
                            loadingColor: widget.loadingColor,
                          ),
                        )
                      : (widget.child ??
                          Text(
                            widget.childText ?? '',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: arabicLanguage ? 16.sp : 16.sp,
                                  color: widget.colorText ?? AppColors.white,
                                  fontWeight: arabicLanguage ? FontWeight.w700 : FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                          )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
/*
 ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(widget.backgroundColor ?? AppColors.white),
            shape: MaterialStatePropertyAll(
              ContinuousRectangleBorder(
                side: BorderSide(color: widget.borderColor ?? AppColors.primaryColor),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
              ),
            ),
          )
 */
