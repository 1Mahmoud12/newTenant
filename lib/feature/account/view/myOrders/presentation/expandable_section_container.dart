import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:flutter/material.dart';

class ExpandableSectionContainer extends StatefulWidget {
  final String title;
  final Widget child;
  final int initialVisibleItems;

  const ExpandableSectionContainer({
    super.key,
    required this.title,
    required this.child,
    this.initialVisibleItems = 2,
  });

  @override
  State<ExpandableSectionContainer> createState() => _ExpandableSectionContainerState();
}

class _ExpandableSectionContainerState extends State<ExpandableSectionContainer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Determine if the child is a Column with children (for partial showing)
    Widget contentWidget = widget.child;
    bool canShowPartially = false;
    List<Widget> childItems = [];

    if (widget.child is Column) {
      final Column column = widget.child as Column;
      if (column.children.isNotEmpty) {
        childItems = column.children;
        canShowPartially = childItems.length > widget.initialVisibleItems;
      }
    }

    // Build the content based on expansion state
    if (canShowPartially && !_isExpanded) {
      // Show limited items
      contentWidget = Column(
        crossAxisAlignment: (widget.child as Column).crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment: (widget.child as Column).mainAxisAlignment ?? MainAxisAlignment.start,
        mainAxisSize: (widget.child as Column).mainAxisSize ?? MainAxisSize.max,
        children: [
          ...childItems.take(widget.initialVisibleItems),
          // See More button
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = true;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See More',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (canShowPartially && _isExpanded) {
      // Show all items with collapse option
      contentWidget = Column(
        crossAxisAlignment: (widget.child as Column).crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment: (widget.child as Column).mainAxisAlignment ?? MainAxisAlignment.start,
        mainAxisSize: (widget.child as Column).mainAxisSize ?? MainAxisSize.max,
        children: [
          ...childItems,
          // See Less button
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = false;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See Less',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_up,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF303030),
                    ),
                  ),
                ),
                if (canShowPartially)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Show Less' : 'Show All',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          contentWidget,
        ],
      ),
    );
  }
}
