import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mamlaka/core/component/buttons/custom_text_button.dart';
import 'package:mamlaka/core/utils/constants.dart';
import 'package:mamlaka/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:mamlaka/core/utils/navigate.dart';
import 'package:mamlaka/core/utils/utils.dart';
import 'package:mamlaka/core/utils/versionAndUpdateApp/check_app_update.dart';

void checkVersion(BuildContext context) async {
  final _checker = AppVersionChecker();

  await _checker.checkUpdate().then((value) async {
    final AppCheckerResult result = value;
    log('Current Version ${value.currentVersion} ==== New Version ${result.newVersion}', level: 10);
    Constants.versionApp = value.currentVersion;
    if (result.canUpdate) {
      context.navigateToPage(
        NewUpdate(
          appUrl: value.appURL ??
              (Platform.isAndroid
                  ? 'https://play.google.com/store/apps/details?id=${Constants.packageName}'
                  : 'https://apps.apple.com/app/id${Constants.appleId}'),
        ),
      );
    }
  });
}

class NewUpdate extends StatelessWidget {
  final String appUrl;

  const NewUpdate({super.key, required this.appUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyWidget(
              emptyImage: EmptyImages.newUpdates,
              data: 'new_updates_are_available'.tr(),
              subData: 'we_have_new_updates_for_our_app'.tr(),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTextButton(
              padding: const EdgeInsets.symmetric(vertical: 16),
              onPress: () {
                Utils.launchURLFunction(appUrl);
              },
              childText: 'update_now'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
