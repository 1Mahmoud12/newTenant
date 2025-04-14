import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String price;
  final String? discountPercentage;
  final Function(bool isNowLiked)? onLikeTap;
  const FlashCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.price,
    this.discountPercentage,
    this.onLikeTap,
  }) : super(key: key);

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    widget.onLikeTap?.call(isLiked);
    // Do something on tap, like call an API or update local state
    debugPrint('Liked: $isLiked for ${widget.title}');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigateToPage(const ProductDetailsView());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CacheImage(
                urlImage: widget.imagePath,
                errorColor: Colors.grey,
                height: 200,
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: toggleLike,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                widget.price,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              if (widget.discountPercentage != null) ...[
                const SizedBox(width: 8),
                Text(
                  '-${widget.discountPercentage}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
