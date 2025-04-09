import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mamlaka/core/themes/colors.dart';
import 'package:mamlaka/core/themes/styles.dart';

class CustomDropDownMenu extends StatefulWidget {
  final String? selectedItem;
  final List<String> items;
  final double? width;
  final int? directionArrowButton;
  final void Function(String?)? onChanged;

  const CustomDropDownMenu({
    super.key,
    required this.selectedItem,
    required this.items,
    this.width,
    this.onChanged,
    this.directionArrowButton,
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  String newSelected = '';

  @override
  void initState() {
    newSelected = widget.selectedItem!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: (MediaQuery.of(context).size.width * (widget.width ?? .9)).w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white, border: Border.all(color: AppColors.greyBorderColor)),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        underline: Container(),
        icon: const SizedBox(),
        iconSize: 0,
        hint: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: FittedBox(
                alignment: context.locale.languageCode == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5).w,
                  child: Text(
                    newSelected.tr(),
                    style: Styles.style14400,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Align(
              // alignment: context.locale.languageCode == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
              child: RotatedBox(
                quarterTurns: widget.directionArrowButton ?? 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        onChanged: (String? newValue) {
          newSelected = newValue!;
          setState(() {});

          widget.onChanged?.call(newValue);
        },
        isExpanded: true,
        borderRadius: BorderRadius.circular(15.r),
        //  autofocus: false,
        focusColor: AppColors.primaryColor,
        dropdownColor: AppColors.white,
        alignment: context.locale.languageCode == 'ar' ? Alignment.centerRight : Alignment.centerLeft,

        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item.tr(),
            child: Container(
              // constraints: BoxConstraints(maxWidth: 120.w),
              // width: 120.w,
              alignment: context.locale.languageCode == 'ar' ? Alignment.centerRight : Alignment.centerLeft,

              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0).w,
                child: Text(
                  item,
                  style: Styles.style12400,
                  overflow: TextOverflow.ellipsis,
                  textAlign: context.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
                ),
              ),
            ),
            onTap: () {
              //debugPrint(widget.selectedItem);
            },
          );
        }).toList(),
      ),
    );
  }
}
