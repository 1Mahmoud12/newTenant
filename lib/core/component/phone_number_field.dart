import 'dart:developer';

import 'package:dobzz_seller/core/component/custom_drop_down_menu.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final EdgeInsets? outPadding;
  const PhoneNumberField({
    super.key,
    required this.controller,
    this.outPadding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      textInputType: TextInputType.phone,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
      outPadding: outPadding ?? const EdgeInsets.symmetric(horizontal: 20),
      controller: controller,
      hintText: 'Name'.tr(),
      labelText: 'Name'.tr(),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 70,
          child: Row(
            children: [
              const Expanded(child: CountryCodeDropdown()),
              const SizedBox(width: 4),
              Container(
                height: 40,
                width: 1,
                color: AppColors.grey.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountryCodeDropdown extends StatelessWidget {
  const CountryCodeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropDownMenu(
      fillColor: AppColors.transparent,
      borderColor: AppColors.transparent,
      onChanged: (value) {
        log(countriesflage[value?.value ?? 0].code);
        AuthCubit.of(context).countryCode = countriesflage[value?.value ?? 0].code;
      },
      selectedItem: DropDownModel(
        name: countriesflage.first.name,
        value: countriesflage.first.id,
        showName: false,
        showImage: true,
        image: countriesflage.first.image,
      ),
      items: countriesflage
          .map(
            (e) => DropDownModel(
              name: e.name,
              value: e.id,
              showName: false,
              showImage: true,
              image: e.image,
            ),
          )
          .toList(),
    );
  }
}
