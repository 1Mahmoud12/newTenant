import 'dart:async';
import 'package:flutter/material.dart';

class SaleCountdownBanner extends StatefulWidget {
  final String saleText;
  final String discountText;
  final String actionText;
  final VoidCallback onActionPressed;
  final DateTime endTime;
  final Color backgroundColor;
  final Color textColor;
  final Color timerBoxColor;
  final Color timerTextColor;
  final Color actionButtonColor;
  final Color actionTextColor;
  final String backgroundImageUrl;

  const SaleCountdownBanner({
    Key? key,
    this.saleText = 'Sale',
    this.discountText = 'Up To 50%',
    this.actionText = 'View',
    required this.onActionPressed,
    required this.endTime,
    this.backgroundColor = Colors.black54,
    this.textColor = Colors.white,
    this.timerBoxColor = Colors.black87,
    this.timerTextColor = Colors.white,
    this.actionButtonColor = Colors.black87,
    this.actionTextColor = Colors.white,
    required this.backgroundImageUrl,
  }) : super(key: key);

  @override
  State<SaleCountdownBanner> createState() => _SaleCountdownBannerState();
}

class _SaleCountdownBannerState extends State<SaleCountdownBanner> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    _remainingTime = widget.endTime.difference(now);
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        image: widget.backgroundImageUrl != null
            ? DecorationImage(
                image: AssetImage(widget.backgroundImageUrl),
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
              widget.saleText,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Discount text
            Text(
              widget.discountText,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            // Timer and action button row
            Row(
              children: [
                _buildTimeBox(
                  _remainingTime.inDays,
                  'Days',
                ),
                const SizedBox(width: 8),
                _buildTimeBox(
                  _remainingTime.inHours % 24,
                  'Hours',
                ),
                const SizedBox(width: 8),
                _buildTimeBox(
                  _remainingTime.inMinutes % 60,
                  'Mins',
                ),
                const SizedBox(width: 8),
                _buildTimeBox(
                  _remainingTime.inSeconds % 60,
                  'Secs',
                ),
                //
              ],
            ),
            const SizedBox(height: 16),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(int value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: widget.timerBoxColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              color: widget.timerTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: widget.timerTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton.icon(
      onPressed: widget.onActionPressed,
      icon: Text(
        widget.actionText,
        style: TextStyle(
          color: widget.actionTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      label: const Icon(
        Icons.arrow_forward,
        size: 16,
        color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.actionButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
