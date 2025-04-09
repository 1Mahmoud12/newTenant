import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamlaka/core/component/buttons/custom_text_button.dart';
import 'package:mamlaka/core/themes/colors.dart';
import 'package:mamlaka/feature/navigation/view/manager/homeBloc/cubit.dart';

Future<void> changeLanguageDialog(BuildContext context) async {
  String locale = context.locale.languageCode;
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Text(
                'change_language'.tr(),
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
                onTap: () => setState(() => locale = 'en'),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: locale == 'en' ? AppColors.primaryColor : AppColors.white,
                        border: Border.all(color: locale == 'en' ? AppColors.transparent : AppColors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text('English', style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
              ),
              const SizedBox(height: 19),
              InkWell(
                onTap: () => setState(() {
                  locale = 'ar';
                }),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: locale == 'ar' ? AppColors.primaryColor : AppColors.white,
                        border: Border.all(color: locale == 'ar' ? AppColors.transparent : AppColors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text('Arabic (العربية)', style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            CustomTextButton(
              onPress: () {
                Navigator.pop(context);
                if (locale != context.locale.languageCode) {
                  locale == 'en'
                      ? BlocProvider.of<HomeCubit>(context).changeLanguage(const Locale('en', 'US'), context)
                      : BlocProvider.of<HomeCubit>(context).changeLanguage(const Locale('ar', 'SA'), context);
                }
                //HomeCubit.of(context).getAllCategories();
              },
              childText: 'update_language'.tr(),
            ),
          ],
        ),
      );
    },
  );
}
