import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of help options with their icons
    final List<Map<String, dynamic>> helpOptions = [
      {
        'title': 'Customer Service'.tr(),
        'icon': AppIcons.customerSerivce,
      },
      {
        'title': 'Whatsapp'.tr(),
        'icon': AppIcons.Whatsapp,
      },
      {
        'title': 'Website'.tr(),
        'icon': AppIcons.Web,
      },
      {
        'title': 'Facebook'.tr(),
        'icon': AppIcons.Facebook,
      },
      {
        'title': 'Twitter'.tr(),
        'icon': AppIcons.Twitter,
      },
      {
        'title': 'Instagram'.tr(),
        'icon': AppIcons.Instagram,
      },
    ];

    return Scaffold(
      appBar: customAppBar(context: context, title: 'Help Center'.tr()),
      body: ListView.separated(
        itemCount: helpOptions.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                helpOptions[index]['icon'],
              ),
              title: Text(
                helpOptions[index]['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              onTap: () {
                // Handle option tap
              },
            ),
          );
        },
      ),
    );
  }
}
