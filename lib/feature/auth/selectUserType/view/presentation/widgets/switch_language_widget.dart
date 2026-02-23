import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/constants.dart';
import 'package:rova_star/feature/navigation/view/manager/homeBloc/cubit.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwitchLanguageWidget extends StatefulWidget {
  const SwitchLanguageWidget({super.key});

  @override
  _SwitchLanguageWidgetState createState() => _SwitchLanguageWidgetState();
}

class _SwitchLanguageWidgetState extends State<SwitchLanguageWidget> {
  bool isEnglishSelected = true; // Initial selection
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        isEnglishSelected = context.locale.languageCode == 'en';
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 160, // Total width to ensure smooth animation
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          color: AppColors.cInActiveTrack,
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: !isEnglishSelected ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: !isEnglishSelected ? 80 : 90, // Half the width of the total width for the button
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(45),
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isEnglishSelected = true;
                      });
                      BlocProvider.of<HomeCubit>(context).changeLanguage(const Locale('en', 'US'), context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                      child: Center(
                        child: Text(
                          'English'.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: !isEnglishSelected ? AppColors.textColor : AppColors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: Constants.tablet ? 14 : 14.sp,
                                fontFamily: 'Inter',
                              ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isEnglishSelected = false;
                      });
                      BlocProvider.of<HomeCubit>(context).changeLanguage(const Locale('ar', 'SA'), context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Center(
                            child: Text(
                              'عربي'.tr(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: !isEnglishSelected ? AppColors.white : AppColors.textColor,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Tajawal',
                                  ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
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
