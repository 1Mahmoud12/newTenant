import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

extension NavigationExtension on BuildContext {
  Future<void> navigateToPage(
    Widget widget, {
    PageTransitionType? pageTransitionType,
    int? animation,
  }) async {
    await Navigator.of(this).push(
      PageTransition(
        child: widget,
        type: pageTransitionType ?? PageTransitionType.fade,
        duration: Duration(milliseconds: animation ?? 300),
      ),
    );
  }

  Future<void> navigateToPageWithReplacement(
    Widget page, {
    int? animation,
  }) async {
    await Navigator.of(this).pushReplacement(
      PageTransition(
        child: page,
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: animation ?? 300),
      ),
    );
  }

  Future<void> navigateToPageWithClearStack(
    Widget page, {
    int? animation,
  }) async {
    await Navigator.of(this).pushAndRemoveUntil(
      PageTransition(
        child: page,
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: animation ?? 300),
      ),
      (route) => false,
    );
  }
}
