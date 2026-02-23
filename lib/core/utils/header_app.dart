import 'package:flutter/material.dart';
import 'package:rova_star/core/themes/styles.dart';

class HeaderApp extends StatelessWidget {
  const HeaderApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Builder',
      textAlign: TextAlign.center,
      style: Styles.styleHeader,
    );
  }
}
