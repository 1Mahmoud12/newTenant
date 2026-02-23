import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/themes/styles.dart';
import 'package:rova_star/core/utils/app_icons.dart';
import 'package:rova_star/core/utils/app_images.dart';
import 'package:rova_star/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ShowToastPosition { top, bottom }

enum ShowToastStatus { success, warning, error }

void customShowToast(
  BuildContext context,
  String message, {
  Color? backgroundColor,
  double? heightRatio,
  ShowToastStatus showToastStatus = ShowToastStatus.success,
  ShowToastPosition showToastPosition = ShowToastPosition.bottom, // New parameter
}) async {
  final OverlayState overlayState = Overlay.of(context);
  final OverlayEntry entry = OverlayEntry(
    builder: (context) => BottomToastOverlayContainer(
      message: message,
      backgroundColor: backgroundColor ?? Colors.white,
      heightRatio: heightRatio ?? 0.075,
      showToastStatus: showToastStatus,
      showToastPosition: showToastPosition,
    ),
  );

  overlayState.insert(entry);
  await Future.delayed(const Duration(seconds: 5));
  entry.remove();
}

class BottomToastOverlayContainer extends StatefulWidget {
  final String message;
  final ShowToastStatus showToastStatus;
  final double heightRatio;
  final Color backgroundColor;
  final ShowToastPosition showToastPosition; // New parameter for position

  const BottomToastOverlayContainer({
    super.key,
    required this.message,
    required this.backgroundColor,
    this.heightRatio = 0.075,
    required this.showToastStatus,
    required this.showToastPosition,
  });

  @override
  State<BottomToastOverlayContainer> createState() => _BottomToastOverlayContainerState();
}

class _BottomToastOverlayContainerState extends State<BottomToastOverlayContainer> with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();

  late Animation<double> slideAnimation = Tween<double>(begin: -0.5, end: 1.0).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCirc,
    ),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      animationController.reverse();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return PositionedDirectional(
          start: MediaQuery.of(context).size.width * 0.1,
          //bottom: (MediaQuery.of(context).size.height * widget.heightRatio! * (slideAnimation.value)) + MediaQuery.viewInsetsOf(context).bottom,
          top: widget.showToastPosition == ShowToastPosition.top
              ? (MediaQuery.of(context).size.height * (slideAnimation.value * widget.heightRatio)) // Move from top to center
              : null, // Only null if toast is not from top
          bottom: widget.showToastPosition == ShowToastPosition.bottom
              ? (MediaQuery.of(context).size.height * widget.heightRatio * (slideAnimation.value)) + MediaQuery.viewInsetsOf(context).bottom
              : null, // Only null if toast is not from bottom
          child: Opacity(
            opacity: slideAnimation.value < 0.0 ? 0.0 : slideAnimation.value,
            child: Material(
              type: MaterialType.transparency,
              child: switch (widget.showToastStatus) {
                ShowToastStatus.success => Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.message,
                                style: Styles.style14500.copyWith(color: AppColors.white),
                                textAlign: widget.message.length < 35 ? TextAlign.center : TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .1),
                        child: Image.asset(AppImages.backGroundSuccessToast),
                      ),
                    ],
                  ),
                ShowToastStatus.warning => Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: AppColors.cBackgroundToast,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(AppIcons.infoIc),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          child: Text(
                            widget.message,
                            style: Styles.style14500.copyWith(color: AppColors.cSecondColor.withOpacityNew(.6)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ShowToastStatus.error => Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.message,
                            style: Styles.style14500.copyWith(color: AppColors.white),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
              },
            ),
          ),
        );
      },
    );
  }
}
