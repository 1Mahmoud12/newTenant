import 'dart:developer';

import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/themes/styles.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DropDownModel {
  final String name;
  final String? image;
  final bool showImage;
  final bool showName;
  final int value;
  DropDownModel({
    required this.name,
    required this.value,
    this.showImage = false,
    this.showName = true,
    this.image,
  });
}

class CustomDropDownMenu extends StatefulWidget {
  final DropDownModel? selectedItem;
  final List<DropDownModel> items;
  final double? width;
  final Color? borderColor;
  final Color? fillColor;
  final TextStyle? textStyleSelected;
  final int? directionArrowButton;
  final double? borderRadius;
  final bool showDropDownIcon;
  final void Function(DropDownModel?)? onChanged;
  final String? nameField;
  final bool hasError;
  final String? errorText;
  final EdgeInsetsGeometry?
      menuItemPadding; // New property for menu item padding
  final EdgeInsetsGeometry?
      buttonPadding; // New property for dropdown button padding
  final double? menuMaxHeight; // Control max height of dropdown menu

  const CustomDropDownMenu({
    super.key,
    required this.selectedItem,
    required this.items,
    this.width,
    this.onChanged,
    this.directionArrowButton,
    this.borderColor,
    this.fillColor,
    this.borderRadius,
    this.showDropDownIcon = true,
    this.textStyleSelected,
    this.nameField,
    this.hasError = false,
    this.errorText,
    this.menuItemPadding, // For controlling padding of menu items
    this.buttonPadding, // For controlling padding of the dropdown button
    this.menuMaxHeight, // For controlling max height of dropdown menu
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  DropDownModel newSelected =
      DropDownModel(name: '', value: -1, showImage: true, showName: false);

  @override
  void initState() {
    newSelected = widget.selectedItem!;
    log('print selected item====>${newSelected.showName}');
    super.initState();
  }

  @override
  void didUpdateWidget(CustomDropDownMenu oldWidget) {
    if (widget.selectedItem != oldWidget.selectedItem) {
      newSelected = widget.selectedItem!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.nameField != null)
          Text(
            widget.nameField!.tr(),
            style: Theme.of(context).textTheme.displayMedium,
          ),
        if (widget.nameField != null) h5,
        Container(
          //width: (MediaQuery.of(context).size.width * (widget.width ?? .9)).w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
            color: widget.fillColor ?? AppColors.white,
            border: Border.all(
              color: widget.hasError
                  ? Colors.red
                  : widget.borderColor ?? AppColors.greyBorderColor,
            ),
          ),

          child: DropdownButton<DropDownModel>(
            underline: Container(),
            icon: const SizedBox(),
            padding: widget.buttonPadding ??
                EdgeInsets.symmetric(horizontal: newSelected.showImage ? 6 : 4),
            iconSize: 0,
            menuMaxHeight: widget.menuMaxHeight,
            hint: Row(
              children: [
                if (newSelected.showName)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        newSelected.name.tr(),
                        style: Styles.style14400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (newSelected.showImage)
                  Expanded(
                    child: newSelected.image!.contains('.svg')
                        ? SvgPicture.asset(
                            newSelected.image!,
                            fit: BoxFit.cover,
                            height: 16,
                            width: 16,
                          )
                        : Image.asset(
                            newSelected.image!,
                            fit: BoxFit.cover,
                          ),
                  ),
                if (widget.showDropDownIcon)
                  Align(
                    // alignment: context.locale.languageCode == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                    child: RotatedBox(
                      quarterTurns: widget.directionArrowButton ?? 0,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
              ],
            ),
            onChanged: (DropDownModel? newValue) {
              newSelected = newValue!;
              setState(() {});

              widget.onChanged?.call(newValue);
            },
            isExpanded: true,
            borderRadius: BorderRadius.circular(15.r),
            //  autofocus: false,
            focusColor: AppColors.primaryColor,
            dropdownColor: AppColors.white,
            alignment: context.locale.languageCode == 'ar'
                ? Alignment.centerRight
                : Alignment.centerLeft,
            style: widget.textStyleSelected ?? Styles.style14400,
            itemHeight: null, // Allow items to determine their own height

            items: widget.items.map((DropDownModel item) {
              return DropdownMenuItem<DropDownModel>(
                value: item,
                child: Container(
                  // constraints: BoxConstraints(maxWidth: 120.w),
                  // width: 120.w,
                  alignment: context.locale.languageCode == 'ar'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                  child: Padding(
                    padding: widget.menuItemPadding ??
                        const EdgeInsets.only(left: 10.0).w,
                    child: item.showImage
                        ? Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: item.image!.contains('.svg')
                                ? SvgPicture.asset(
                                    item.image!,
                                    fit: BoxFit.cover,
                                    height: 16,
                                    width: 16,
                                  )
                                : Image.asset(
                                    item.image!,
                                    fit: BoxFit.cover,
                                  ),
                          )
                        : Text(
                            item.name,
                            style: Styles.style12400,
                            overflow: TextOverflow.ellipsis,
                            textAlign: context.locale.languageCode == 'ar'
                                ? TextAlign.right
                                : TextAlign.left,
                            maxLines: 1,
                          ),
                  ),
                ),
                onTap: () {
                  //debugPrint(widget.selectedItem);
                },
              );
            }).toList(),
          ),
        ),
        if (widget.hasError && widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              widget.errorText!.tr(),
              style: TextStyle(
                color: Colors.red,
                fontSize: Constants.tablet ? 12 : 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}
