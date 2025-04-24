import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/cart/view/manager/addToCart/cubit/add_to_cart_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/addToWhishlist/cubit/add_to_wish_list_cubit.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProductCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String price;
  final String? discountPercentage;
  final Function(bool isNowLiked)? onLikeTap;
  final int productId;
  final bool initialLiked;
  const ProductCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.price,
    this.discountPercentage,
    this.onLikeTap,
    required this.initialLiked,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  void initState() {
    super.initState();
    isLiked = widget.initialLiked;
  }

  bool isLiked = false;
  AddToWishListCubit addToWishListCubit = AddToWishListCubit();
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    widget.onLikeTap?.call(isLiked);
    debugPrint('Liked: $isLiked for ${widget.title}');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigateToPage(
          ProductDetailsView(
            initialLiked: widget.initialLiked,
            productId: widget.productId,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CacheImage(
                  urlImage: widget.imagePath,
                  errorColor: Colors.grey,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.price,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  s,
                  AddToCartButton(
                    productId: widget.productId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddToCartButton extends StatefulWidget {
  const AddToCartButton({
    super.key,
    required this.productId,
  });
  final int productId;
  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  AddToCartCubit addToCartCubit = AddToCartCubit();
  bool _isAdded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addToCartCubit
            .addToCart(
          context: context,
          productId: widget.productId,
        )
            .then((_) {
          setState(() {
            _isAdded = true;
          });

          // Optional: Reset back to cart icon after a delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isAdded = false;
              });
            }
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isAdded
              ? Colors.green // Change color when added if desired
              : AppColors.primaryColor,
        ),
        child: _isAdded
            ? const Icon(
                Icons.check,
                color: Colors.white,
              ) // Replace with your check icon
            : SvgPicture.asset(AppIcons.unSelectedCartC),
      ),
    );
  }
}
