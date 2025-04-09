import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mamlaka/core/component/fields/custom_text_form_field.dart';
import 'package:mamlaka/core/themes/colors.dart';
import 'package:mamlaka/core/utils/app_icons.dart';
import 'package:mamlaka/core/utils/bottomSheet/select_county_code_dialog.dart';
import 'package:mamlaka/core/utils/constants_models.dart';
import 'package:mamlaka/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:mamlaka/feature/auth/manager/authBloc/auth_state.dart';

class PhonePickerField extends StatelessWidget {
  const PhonePickerField({
    super.key,
    required this.cubit,
    this.helperText,
    this.validator,
    this.enable = true,
  });

  final String? helperText;
  final AuthCubit cubit;
  final Function? validator;
  final bool? enable;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomTextFormField(
            controller: cubit.phoneController,
            hintText: 'x xxxx xxxx',

            labelText: 'phone_number',
            outPadding: EdgeInsets.zero,
            textInputType: TextInputType.number,
            inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
            // onChange: (value) {
            //   if (value.isNotEmpty && cubit.phoneController.text[0] != '0') {
            //     cubit.phoneController.text = '0$value';
            //   }
            // },
            prefixIcon: InkWell(
              onTap: () async {
                await selectCountryCodeDialog(context, country: cubit.country, onPress: () {}).then(
                  (value) {
                    cubit.setCountryCodeId(value.id);
                  },
                );
              },
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      '+${cubit.country.code}',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.cB700),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    SvgPicture.asset(AppIcons.upDownIc),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

int? getCountryCode(CountryCode countryCode) =>
    ConstantsModels.countryCodeModel?.data?.firstWhere((element) => '+${element.code}' == countryCode.dialCode).id;
