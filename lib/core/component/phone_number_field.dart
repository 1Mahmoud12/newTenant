import 'dart:developer';
import 'package:dobzz_seller/core/component/custom_drop_down_menu.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final EdgeInsets? outPadding;

  const PhoneNumberField({
    super.key,
    required this.controller,
    this.outPadding,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  // Default to the first country in the list
  String _countryCode = countriesflage.first.code;
  String _phoneHint = '05xxxxxxxx'; // Default Saudi format

  void _updatePhoneHint(String countryCode) {
    setState(() {
      _countryCode = countryCode;
      // Update hint based on country code
      switch (countryCode) {
        case '+966': // Saudi Arabia
          _phoneHint = '05xxxxxxxx';
          break;
        case '+2': // Egypt
          _phoneHint = '01xxxxxxxxx';
          break;
        case '+973': // Bahrain
          _phoneHint = 'xxxxxxxx';
          break;
        default:
          _phoneHint = '01xxxxxxxxx';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize with default country
    _updatePhoneHint(_countryCode);
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.of(context);

    return CustomTextFormField(
      textInputType: TextInputType.phone,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
      outPadding: widget.outPadding ?? const EdgeInsets.symmetric(horizontal: 20),
      controller: widget.controller,
      hintText: 'Phone'.tr(),
      labelText: _phoneHint.tr(),
      validator: (value) => _validatePhoneNumber(value, _countryCode),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 70,
          child: Row(
            children: [
              Expanded(
                child: CountryCodeDropdown(
                  onCountryChanged: (countryCode) {
                    _updatePhoneHint(countryCode);
                    authCubit.countryCode = countryCode;
                  },
                ),
              ),
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

  String? _validatePhoneNumber(String? value, String countryCode) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required'.tr();
    }

    // Different validation rules based on country code
    if (countryCode == '+966') {
      // Saudi Arabia
      // Saudi phone numbers: typically 9 digits after 05
      final RegExp regExp = RegExp(r'^(0|5)\d{8}$');
      if (!regExp.hasMatch(value)) {
        return 'Enter valid Saudi phone number'.tr();
      }
    } else if (countryCode == '+2') {
      // Egypt
      // Egyptian phone numbers: 10 digits starting with 01
      final RegExp regExp = RegExp(r'^(01)[0-2,5]\d{8}$');
      if (!regExp.hasMatch(value)) {
        return 'Enter valid Egyptian phone number'.tr();
      }
    } else if (countryCode == '+973') {
      // Bahrain
      // Bahrain phone numbers: 8 digits
      final RegExp regExp = RegExp(r'^\d{8}$');
      if (!regExp.hasMatch(value)) {
        return 'Enter valid Bahrain phone number'.tr();
      }
    } else {
      // Generic validation for other countries
      final RegExp regExp = RegExp(r'^\d{7,15}$');
      if (!regExp.hasMatch(value)) {
        return 'Enter valid phone number'.tr();
      }
    }

    return null;
  }
}

class CountryCodeDropdown extends StatelessWidget {
  final Function(String countryCode) onCountryChanged;

  const CountryCodeDropdown({
    super.key,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropDownMenu(
      fillColor: AppColors.transparent,
      borderColor: AppColors.transparent,
      onChanged: (value) {
        final selectedCountry = countriesflage[value?.value ?? 0];
        log(selectedCountry.code);
        AuthCubit.of(context).countryCode = selectedCountry.code;
        onCountryChanged(selectedCountry.code);
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

List<CountryFlag> countriesflage = [
  CountryFlag(id: 0, name: 'SA', code: '+966', image: AppIcons.SAIc),
  CountryFlag(id: 1, name: 'EG', code: '+2', image: AppIcons.EGIc),
  CountryFlag(id: 2, name: 'EM', code: '+973', image: AppIcons.AEIc),
];

class CountryFlag {
  final int id;
  final String name;
  final String code;
  final String image;

  CountryFlag({
    required this.id,
    required this.name,
    required this.code,
    required this.image,
  });
}
