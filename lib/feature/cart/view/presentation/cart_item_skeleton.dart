import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartItemSkeleton extends StatelessWidget {
  const CartItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Image skeleton
            Bone.square(
              size: 100,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Title skeleton
                      Expanded(
                        child: Bone.text(
                          fontSize: Constants.tablet ? 12 : 12.sp,
                          width: 120,
                        ),
                      ),
                      w7,
                      // Delete icon skeleton
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.2))),
                        child: Bone.icon(
                          size: Constants.tablet ? 15 : 15.sp,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Size skeleton
                  Bone.text(
                    width: 60,
                    fontSize: Constants.tablet ? 14 : 14.sp,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      // Price skeleton
                      Bone.text(
                        width: 50,
                        fontSize: Constants.tablet ? 14 : 14.sp,
                      ),
                      const Spacer(),
                      // Quantity control skeletons
                      Bone.icon(
                        size: 20.sp,
                      ),
                      const SizedBox(width: 8),
                      Bone.text(
                        width: 20,
                        fontSize: Constants.tablet ? 16 : 16.sp,
                      ),
                      const SizedBox(width: 8),
                      Bone.icon(
                        size: 20.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
