import 'dart:async';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/home/data/models/sales_model.dart';
import 'package:dobzz_seller/feature/home/views/manager/salesBanner/cubit/sales_banner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Countdown Timer Components
class TimerBox extends StatelessWidget {
  final int value;
  final String label;
  final Color boxColor;
  final Color textColor;

  const TimerBox({
    Key? key,
    required this.value,
    required this.label,
    required this.boxColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String actionText;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;

  const ActionButton({
    Key? key,
    required this.actionText,
    required this.onPressed,
    required this.buttonColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Text(
        'View',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      label: Icon(
        Icons.arrow_forward,
        size: 16,
        color: textColor,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

// Refactored Sales Countdown Banner
class SaleCountdownBanner extends StatefulWidget {
  final SaleBannerData bannerData;
  final VoidCallback onActionPressed;

  const SaleCountdownBanner({
    Key? key,
    required this.bannerData,
    required this.onActionPressed,
  }) : super(key: key);

  @override
  State<SaleCountdownBanner> createState() => _SaleCountdownBannerState();
}

class _SaleCountdownBannerState extends State<SaleCountdownBanner> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late Duration _remainingTime;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();

    // Setup animation for a cool pulsing effect
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    final endTime = DateTime.parse(widget.bannerData.endTime ?? DateTime.now().toIso8601String());
    _remainingTime = endTime.difference(now);
    if (_remainingTime.isNegative) {
      _remainingTime = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _calculateRemainingTime();
        if (_remainingTime == Duration.zero) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8.0),
          image: widget.bannerData.pannerImagePath != null
              ? DecorationImage(
                  image: NetworkImage(widget.bannerData.pannerImagePath!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sale title text
              Text(
                widget.bannerData.pannerHeading ?? 'Sale',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Discount text
              Text(
                widget.bannerData.pannerDiscount ?? 'Up To 50%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 10),

              // Timer and action button row
              Row(
                children: [
                  TimerBox(
                    value: _remainingTime.inDays,
                    label: 'Days',
                    boxColor: Colors.black87,
                    textColor: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  TimerBox(
                    value: _remainingTime.inHours % 24,
                    label: 'Hours',
                    boxColor: Colors.black87,
                    textColor: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  TimerBox(
                    value: _remainingTime.inMinutes % 60,
                    label: 'Mins',
                    boxColor: Colors.black87,
                    textColor: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  TimerBox(
                    value: _remainingTime.inSeconds % 60,
                    label: 'Secs',
                    boxColor: Colors.black87,
                    textColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ActionButton(
                actionText: widget.bannerData.pannerTitle ?? 'View',
                onPressed: widget.onActionPressed,
                buttonColor: Colors.black87,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Loading Animation for Sales Banner
class SalesBannerLoadingWidget extends StatefulWidget {
  const SalesBannerLoadingWidget({Key? key}) : super(key: key);

  @override
  State<SalesBannerLoadingWidget> createState() => _SalesBannerLoadingWidgetState();
}

class _SalesBannerLoadingWidgetState extends State<SalesBannerLoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                colors: [
                  Colors.grey[800]!,
                  Colors.grey[700]!,
                  Colors.grey[800]!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading Sales Banner...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget to integrate with BLoC
class SalesBannerWidget extends StatelessWidget {
  const SalesBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesBannerCubit, SalesBannerState>(
      builder: (context, state) {
        if (state is SalesBannerLoading) {
          return const SalesBannerLoadingWidget();
        } else if (state is SalesBannerSuccess) {
          final bannerData = ConstantsModels.salesBannerModel?.data;

          // Check if banner data is valid and sale is still active
          if (bannerData != null && bannerData.isValid == true) {
            return SaleCountdownBanner(
              bannerData: bannerData,
              onActionPressed: () {
                // Handle navigation based on selectionType
                final selectionType = bannerData.selectionType;
                if (selectionType == 'product' && bannerData.productId != null) {
                  // Navigate to product detail
                  // Navigator.push(...);
                } else if (selectionType == 'category' && bannerData.categoryId != null) {
                  // Navigate to category
                  // Navigator.push(...);
                }
              },
            );
          } else {
            // No valid banner to show
            return const SizedBox.shrink();
          }
        } else if (state is SalesBannerError) {
          // You might want to handle the error state differently
          return const SizedBox.shrink();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
