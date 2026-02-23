import 'package:flutter/material.dart';
import 'package:rova_star/core/utils/app_images.dart';

class ScaffoldWithBackground extends StatelessWidget {
  final Widget child;
  final List<Widget>? persistentFooterButtons;

  const ScaffoldWithBackground({super.key, required this.child, this.persistentFooterButtons});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.backgroundScaffold),
              alignment: Alignment.topRight,
              colorFilter: ColorFilter.mode(Color(0xff737373), BlendMode.srcIn),
            ),
          ),
          child: child,
        ),
      ),
      persistentFooterButtons: persistentFooterButtons,
    );
  }
}
