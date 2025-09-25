import 'dart:io';

import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/cart/view/manager/cartItems/cubit/cart_items_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/presentation/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CartFloatingAB extends StatelessWidget {
  final Function()? onTap;
  const CartFloatingAB({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      margin: EdgeInsets.only(
        bottom: Platform.isIOS ? 55 : 70,
      ), // Adjust this value to sit above the nav bar
      child: FloatingActionButton(
        shape: const CircleBorder(), // Optional, but ensures circle shape
        backgroundColor: AppColors.primaryColor,
        onPressed: onTap ??
            () {
              context.navigateToPage(const CartView());
            },
        child: Stack(
          children: [
            SvgPicture.asset(
              AppIcons.unSelectedCartC,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            BlocBuilder<CartItemsCubit, CartItemsState>(
              builder: (context, state) {
                return Positioned(
                  top: 10,
                  right: 10,
                  child: Constants.cartItems != 0
                      ? Container(
                          height: 13,
                          width: 13,
                          decoration: const BoxDecoration(color: Color(0xffF13658), shape: BoxShape.circle),
                          child: FittedBox(
                            child: Text(
                              '${Constants.cartItems}',
                              style:
                                  Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      : const SizedBox(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
