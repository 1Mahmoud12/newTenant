import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/item_above_modal_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Country {
  final int id;
  final String name;
  final String code;
  final String image;

  Country({required this.id, required this.name, required this.code, required this.image});
}

List<Country> countries = [
  Country(id: 1, name: 'Saudi Arabia', code: '966', image: AppIcons.SAIc),
  Country(id: 2, name: 'Egypt', code: '20', image: AppIcons.EGIc),
  Country(id: 3, name: 'Palestine', code: '970', image: AppIcons.PSIc),
  Country(id: 4, name: 'United Arab Emirates', code: '971', image: AppIcons.AEIc),
];
Future<Country> selectCountryCodeDialog(BuildContext context, {required Country country, required Function onPress}) async {
  Country selectedCountry = country;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 8,
                ),
                const ItemAboveModalBottomSheet(),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'select_country_code'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ...countries
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          selectedCountry = e;
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: Durations.medium1,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cB50))),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                e.image,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                e.name,
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.cB900),
                              ),
                              const SizedBox(width: 12),
                              const Spacer(),
                              Text(
                                '+${e.code}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(fontWeight: FontWeight.w500, color: AppColors.cB700.withOpacityNew(.3)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      );
    },
  );
  return selectedCountry;
}
