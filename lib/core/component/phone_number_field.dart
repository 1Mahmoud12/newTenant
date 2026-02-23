import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rova_star/core/component/custom_drop_down_menu.dart';
import 'package:rova_star/core/component/fields/custom_text_form_field.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/app_icons.dart';
import 'package:rova_star/core/utils/extensions.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/auth/manager/authBloc/auth_cubit.dart';

class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final EdgeInsets? outPadding;
  final String? initialCountryCode; // New parameter for initial country code
  final bool? enabled;
  const PhoneNumberField({
    super.key,
    required this.controller,
    this.outPadding,
    this.initialCountryCode,
    this.enabled = true, // Add this parameter
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late String _countryCode;
  late String _phoneHint;
  late int _selectedCountryIndex;

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
    // Initialize with provided country code or default
    if (widget.initialCountryCode != null) {
      // Find the index of the country with the matching code
      final countryIndex = countriesflage.indexWhere(
        (country) => country.code == widget.initialCountryCode,
      );

      // If found, use that index, otherwise default to 0
      _selectedCountryIndex = countryIndex >= 0 ? countryIndex : 0;
      _countryCode = countriesflage[_selectedCountryIndex].code;
    } else {
      // Default to the first country in the list
      _selectedCountryIndex = 0;
      _countryCode = countriesflage.first.code;
    }

    // Initialize the phone hint based on the selected country code
    _updatePhoneHint(_countryCode);

    // Update AuthCubit with the initial country code
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthCubit.of(context).countryCode = _countryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.of(context);

    return CustomTextFormField(
      inputFormatters: AuthCubit.of(context).countryCode == '+966'
          ? [
              TextInputFormatter.withFunction((oldValue, newValue) {
                final text = newValue.text;

                if (text.isEmpty) return newValue;

                // Handle +9665XXXXXXXX
                if (text.startsWith('+966') && text.length > 4 && text[4] == '5') {
                  final trimmed = text.substring(4);
                  final clampedLength = trimmed.length > 9 ? 9 : trimmed.length;
                  final trimmedText = trimmed.substring(0, clampedLength);

                  return TextEditingValue(
                    text: trimmedText,
                    selection: TextSelection.collapsed(offset: clampedLength),
                  );
                }

                if (!text.startsWith('5')) {
                  Utils.showToast(title: 'Saudi numbers start with 5'.tr(), state: UtilState.error);
                  return oldValue;
                }

                if (text.length > 9) {
                  final trimmedText = text.substring(0, 9);
                  return TextEditingValue(
                    text: trimmedText,
                    selection: const TextSelection.collapsed(offset: 9),
                  );
                }

                return newValue;
              }),
            ]
          : null,
      enable: widget.enabled,
      textInputType: TextInputType.phone,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
      outPadding: widget.outPadding ?? const EdgeInsets.symmetric(horizontal: 20),
      controller: widget.controller,
      hintText: 'Phone'.tr(),
      hintStyle: TextStyle(color: AppColors.primaryColor.withOpacityNew(0.5)),
      //  labelText: _phoneHint.tr(),
      validator: (value) => _validatePhoneNumber(value, _countryCode),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 70,
          child: Row(
            children: [
              Expanded(
                child: CountryCodeDropdown(
                  initialCountryIndex: _selectedCountryIndex, // Pass the selected index
                  onCountryChanged: (countryCode) {
                    _updatePhoneHint(countryCode);
                    authCubit.countryCode = countryCode;
                    authCubit.loginPhoneController.clear();
                  },
                ),
              ),
              const SizedBox(width: 4),
              Container(
                height: 40,
                width: 1,
                color: AppColors.grey.withOpacityNew(0.3),
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
  final int initialCountryIndex; // Add parameter for initial country index

  const CountryCodeDropdown({
    super.key,
    required this.onCountryChanged,
    this.initialCountryIndex = 0, // Default to first country
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
        name: countriesflage[initialCountryIndex].name,
        value: countriesflage[initialCountryIndex].id,
        showName: false,
        showImage: true,
        image: countriesflage[initialCountryIndex].image,
      ),
      items: countriesflage
          .map(
            (e) => DropDownModel(
              name: e.name,
              value: e.id,
              showImage: true,
              showName: false,
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
