import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomList extends StatefulWidget {
  final List<String> tabs;
  final void Function(int index)? onTabChanged;
  final bool? prefixIcon;
  final List<IconData>? icons; // Add icons list

  const CustomList({
    Key? key,
    required this.tabs,
    this.onTabChanged,
    this.prefixIcon = false,
    this.icons, // Accept icons list
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
                  color: isSelected ? AppColors.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryColor : Colors.grey.withOpacity(0.3),
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
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    Text(
                      widget.tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
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
