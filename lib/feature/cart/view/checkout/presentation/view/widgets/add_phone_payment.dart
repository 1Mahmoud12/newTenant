import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shows a modal bottom sheet for entering Saudi Arabian phone numbers only
///
/// [onSubmit] is called when the user submits a valid phone number
/// [initialPhoneNumber] can be provided to pre-fill the phone field
Future<void> showSaudiPhoneBottomSheet({
  required BuildContext context,
  required Function(String phoneNumber) onSubmit,
  String? initialPhoneNumber,
}) async {
  final phoneController = TextEditingController(text: initialPhoneNumber);
  final formKey = GlobalKey<FormState>();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.scaffoldBackGround,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Saudi Phone Number To Stc Payment'.tr(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SaudiPhoneNumberField(
                controller: phoneController,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      onSubmit(phoneController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Submit'.tr()),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}

class SaudiPhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final EdgeInsets? outPadding;
  final bool? enabled;

  const SaudiPhoneNumberField({
    super.key,
    required this.controller,
    this.outPadding,
    this.enabled = true,
  });

  @override
  State<SaudiPhoneNumberField> createState() => _SaudiPhoneNumberFieldState();
}

class _SaudiPhoneNumberFieldState extends State<SaudiPhoneNumberField> {
  final String _countryCode = '+966';
  final String _phoneHint = '05xxxxxxxx';

  @override
  void initState() {
    super.initState();
    // Set the country code in auth cubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthCubit.of(context).countryCode = _countryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      enable: widget.enabled,
      textInputType: TextInputType.phone,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
      outPadding: widget.outPadding ?? EdgeInsets.zero,
      controller: widget.controller,
      hintText: _phoneHint,
      validator: _validateSaudiPhoneNumber,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      onChange: (String value) {
        if (value.length == 1 && value != '0') {
          widget.controller.text = '05$value';
          widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.controller.text.length),
          );
        }
      },
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 70,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.SAIc,
                      width: 24,
                      height: 24,
                    ),
                  ],
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

  String? _validateSaudiPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required'.tr();
    }

    return null;
  }
}
