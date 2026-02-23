import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../themes/styles.dart';

AppBar shareAppBar(BuildContext context, {required String nameAppBar, bool notificationIcon = true}) {
  return AppBar(
    title: FittedBox(
      child: Text(
        nameAppBar.tr(),
        textAlign: TextAlign.center,
        style: Styles.style20300,
      ),
    ),
    actions: const [
      //  if (notificationIcon) const NotificationIconWidget(),
      SizedBox(
        width: 28,
      ),
    ],
  );
}
