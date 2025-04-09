import 'package:flutter/material.dart';
import 'package:mamlaka/core/themes/colors.dart';

class ItemAboveModalBottomSheet extends StatelessWidget {
  const ItemAboveModalBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 5,
          decoration: ShapeDecoration(
            color: AppColors.grey.withOpacity(.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ],
    );
  }
}
