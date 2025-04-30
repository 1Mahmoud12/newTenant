import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG support

class CustomList extends StatefulWidget {
  final List tabs;
  final void Function(int index)? onTabChanged;
  final bool? prefixIcon;
  final List? icons;
  final List<String>? svgIcons; // New property for SVG icons
  final bool useSvgIcons; // Flag to determine if using SVG or Material icons
  final bool borderOnlySelection; // Property for border-only selection
  final bool showTabs; // New property to show or hide tabs
  final int? initialSelectedIndex; // New property for initial selection

  const CustomList({
    Key? key,
    required this.tabs,
    this.onTabChanged,
    this.prefixIcon = false,
    this.icons,
    this.svgIcons, // New parameter for SVG paths
    this.useSvgIcons = false, // Default to false to use Material icons
    this.borderOnlySelection = false, // Default to false to maintain original behavior
    this.showTabs = true, // Default to true to show tabs
    this.initialSelectedIndex, // Default is null, meaning no selection initially
  }) : super(key: key);

  @override
  State createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  int? selectedIndex; // Changed to nullable

  @override
  void initState() {
    super.initState();
    // Initialize selectedIndex with the value provided through initialSelectedIndex
    selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.tabs.length, (index) {
          final isSelected = selectedIndex != null && index == selectedIndex;

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
                    if (widget.prefixIcon! &&
                        ((widget.useSvgIcons && widget.svgIcons != null && index < widget.svgIcons!.length) ||
                            (!widget.useSvgIcons && widget.icons != null && index < widget.icons!.length)))
                      Padding(
                        padding: widget.showTabs ? const EdgeInsets.only(right: 6.0) : EdgeInsets.zero,
                        child: widget.useSvgIcons
                            ? SvgPicture.asset(
                                widget.svgIcons![index],
                                height: Constants.tablet ? 18 : 18.sp,
                                width: Constants.tablet ? 18 : 18.sp,
                                //  colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
                              )
                            : Icon(
                                widget.icons![index],
                                size: Constants.tablet ? 18 : 18.sp,
                                color: textColor,
                              ),
                      ),
                    if (widget.showTabs)
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
