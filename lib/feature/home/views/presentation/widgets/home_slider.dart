import 'dart:async';

import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/network/end_points.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/home/views/manager/slider/cubit/slider_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final PageController controller = PageController();
  final SliderCubit _sliderCubit = SliderCubit();
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (ConstantsModels.sliderModel == null) {
      _sliderCubit.getSlider(context: context);
    }

    // Start auto-scrolling timer after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    // Cancel any existing timer
    _autoScrollTimer?.cancel();

    // Create a new timer that fires every 5 seconds
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final sliders = ConstantsModels.sliderModel?.data?.sliders;
      final sliderCount = sliders?.length ?? 3;

      if (sliderCount > 0) {
        _currentPage = (_currentPage + 1) % sliderCount;

        // Animate to the next page
        if (controller.hasClients) {
          controller.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _sliderCubit,
      child: BlocConsumer<SliderCubit, SliderState>(
        listener: (context, state) {
          if (state is SliderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.e)),
            );
          }
        },
        builder: (context, state) {
          // Get slider from landpage model
          final banner = ConstantsModels.landPageModel?.data?.themJson?.homepageBanner;
          final imageUrl = banner?.bgImg;
          final sliders = imageUrl != null ? [imageUrl] : [];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 130,
                  child: PageView(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: List.generate(
                      sliders.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          right: context.locale.languageCode == 'ar' ? 0 : 5,
                          left: context.locale.languageCode == 'ar' ? 5 : 0,
                        ),
                        child: CacheImage(
                          urlImage: '${EndPoints.domain}/${sliders[index]}',
                          errorColor: Colors.grey,
                          borderRadius: 12,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (controller.hasClients && sliders.isNotEmpty)
                  SmoothPageIndicator(
                    controller: controller,
                    count: sliders.length,
                    effect: const WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.primaryColor,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
