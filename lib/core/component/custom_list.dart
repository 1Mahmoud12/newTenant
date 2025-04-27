import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomList extends StatefulWidget {
  final List<String> tabs;
  final void Function(int index)? onTabChanged;
  final bool? prefixIcon;
  final List<IconData>? icons;
  final bool borderOnlySelection; // New property for border-only selection

  const CustomList({
    Key? key,
    required this.tabs,
    this.onTabChanged,
    this.prefixIcon = false,
    this.icons,
    this.borderOnlySelection = false, // Default to false to maintain original behavior
  }) : super(key: key);

  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.tabs.length, (index) {
          final isSelected = index == selectedIndex;

          // Determine colors based on selection style
          Color backgroundColor = Colors.white;
          Color textColor = Colors.black;
          Color borderColor = Colors.grey.withOpacity(0.3);

          if (isSelected) {
            if (widget.borderOnlySelection) {
              // Border-only selection style
              backgroundColor = Colors.white;
              textColor = AppColors.primaryColor;
              borderColor = AppColors.primaryColor;
            } else {
              // Original filled selection style
              backgroundColor = AppColors.primaryColor;
              textColor = Colors.white;
              borderColor = AppColors.primaryColor;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                if (widget.onTabChanged != null) {
                  widget.onTabChanged!(index);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: borderColor,
                    width: isSelected ? 1.5 : 1.0, // Make selected border slightly thicker
                  ),
                ),
                child: Row(
                  children: [
                    if (widget.prefixIcon! && widget.icons != null && index < widget.icons!.length)
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Icon(
                          widget.icons![index],
                          size: 18.sp,
                          color: textColor,
                        ),
                      ),
                    Text(
                      widget.tabs[index],
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
