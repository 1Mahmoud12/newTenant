import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: 130,
            child: PageView(
              controller: controller,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    right: context.locale.languageCode == 'ar' ? 0 : 5,
                    left: context.locale.languageCode == 'ar' ? 5 : 0,
                  ),
                  child: const CacheImage(
                    urlImage: '',
                    errorColor: Colors.grey,
                    borderRadius: 12,
                    height: 100,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SmoothPageIndicator(
            controller: controller,
            count: 3,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
