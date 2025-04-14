import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/feature/navigation/view/manager/homeBloc/cubit.dart';

Future<void> appModeDialog(BuildContext context) async {
  bool modeApp = darkModeValue;
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Text(
                'app_mode'.tr(),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.dividerColor)),
                  child: const Icon(
                    Icons.close,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => setState(() => modeApp = false),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: modeApp ? AppColors.white : AppColors.primaryColor,
                        border: Border.all(color: modeApp ? AppColors.black : AppColors.transparent),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'light_mode'.tr(),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: darkModeValue ? AppColors.white : AppColors.black,
                          ),
                    ),
                    const Spacer(),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 19.31,
                            offset: const Offset(0, 4.83), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 19),
              InkWell(
                onTap: () => setState(() {
                  modeApp = true;
                }),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: modeApp ? AppColors.primaryColor : AppColors.white,
                        border: Border.all(color: modeApp ? AppColors.transparent : AppColors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'dark_mode'.tr(),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black),
                    ),
                    const Spacer(),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.black,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 19.31,
                            offset: const Offset(0, 4.83), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            CustomTextButton(
              onPress: () {
                Navigator.pop(context);
                if (modeApp != darkModeValue) {
                  BlocProvider.of<HomeCubit>(context).changeTheme(context);
                }
              },
              childText: 'update_mode'.tr(),
            ),
          ],
        ),
      );
    },
  );
}
