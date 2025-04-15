import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/custom_drop_down_menu.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:flutter/material.dart';

class MyDetailsView extends StatefulWidget {
  const MyDetailsView({super.key});

  @override
  State<MyDetailsView> createState() => _MyDetailsViewState();
}

class _MyDetailsViewState extends State<MyDetailsView> {
  List<DropDownModel> genderList = [
    DropDownModel(name: 'Male', value: 0),
    DropDownModel(name: 'Female', value: 1),
  ];
  final TextEditingController _dobController = TextEditingController();
  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), // default date
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'My Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextFormField(
              nameField: 'Full Name',
              controller: TextEditingController(),
              hintText: ' ',
            ),
            h10,
            CustomTextFormField(
              nameField: 'Email Address',
              controller: TextEditingController(),
              hintText: ' ',
            ),
            h10,
            CustomTextFormField(
              nameField: 'Date of Birth',
              controller: _dobController,
              hintText: ' ',
              suffixIcon: IconButton(
                icon: const Icon(Icons.date_range),
                onPressed: () => _selectDate(context),
              ),
            ),
            h10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomDropDownMenu(
                nameField: 'Gender',
                borderColor: Colors.grey.withOpacity(0.2),
                selectedItem: DropDownModel(name: 'Male', value: 0),
                items: genderList,
              ),
            ),
            h10,
            CustomTextFormField(
              textInputType: TextInputType.number,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
              outPadding: const EdgeInsets.symmetric(horizontal: 20),
              controller: TextEditingController(),
              hintText: ' ',
              nameField: 'Phone Number',
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomDropDownMenu(
                          fillColor: AppColors.transparent,
                          borderColor: AppColors.transparent,
                          selectedItem: DropDownModel(
                            name: countriesflage.first.name,
                            value: countriesflage.first.id,
                            showName: false,
                            showImage: true,
                            image: countriesflage.first.image,
                          ),
                          items: countriesflage
                              .map(
                                (e) => DropDownModel(name: e.name, value: e.id, showName: false, showImage: true, image: e.image),
                              )
                              .toList(),
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
            ),
            h30,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextButton(
                borderRadius: 10,
                onPress: () {},
                childText: 'Submit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
