import 'package:flutter/material.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';

class SliderWithThumb extends StatefulWidget {
  final double valueSlider;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;

  const SliderWithThumb({super.key, required this.valueSlider, this.activeTrackColor, this.inactiveTrackColor});

  @override
  State<SliderWithThumb> createState() => _SliderWithThumbState();
}

class _SliderWithThumbState extends State<SliderWithThumb> {
  @override
  Widget build(BuildContext context) {
    final double valueSlider = context.screenWidth * .5;

    return Container(
      width: context.screenWidth,
      height: 12,
      decoration: BoxDecoration(
        color: widget.inactiveTrackColor ?? AppColors.cInActiveTrack,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: valueSlider,
                height: 6,
                margin: const EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: widget.activeTrackColor ?? AppColors.cBorderLessColor,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
              ),
            ],
          ),
          ThumbAndActiveTrackWidget(valueSlider: valueSlider),
        ],
      ),
    );
  }
}

class ThumbAndActiveTrackWidget extends StatelessWidget {
  const ThumbAndActiveTrackWidget({
    super.key,
    required this.valueSlider,
    this.activeTrackColor,
  });

  final double valueSlider;
  final Color? activeTrackColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: (valueSlider <= 10 ? 10 : valueSlider) - 10,
        ),
        ClipOval(
          child: Container(
            width: 12,
            height: 12,
            color: activeTrackColor ?? AppColors.cBorderLessColor,
          ),
        ),
      ],
    );
  }
}
