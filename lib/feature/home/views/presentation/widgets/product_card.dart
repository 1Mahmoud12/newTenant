import 'dart:async';

import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/cart/view/manager/addToCart/cubit/add_to_cart_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/manager/cartItems/cubit/cart_items_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/addToWhishlist/cubit/add_to_wish_list_cubit.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_details_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProductCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String price;
  final String? discountPercentage;

  final String description; // Added description parameter
  final double rating; // Added rating parameter
  final Function(bool isNowLiked)? onLikeTap;
  final int productId;
  final bool initialLiked;

  const ProductCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.price,
    this.discountPercentage,
    this.description = 'No description available',
    this.rating = 0.0,
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
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.grey.withOpacity(0.3),
          // ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // important

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CacheImage(
                  urlImage: widget.imagePath,
                  errorColor: Colors.grey,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.contain,
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: Constants.tablet ? 12 : 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Review(widget: widget),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.description,
                style: TextStyle(
                  fontSize: Constants.tablet ? 10 : 10.sp,
                  color: Colors.grey.shade400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        Text(
                          widget.price,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        w5,
                        SvgPicture.asset(
                          AppIcons.currency,
                          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                          height: 14,
                          width: 14,
                        ),
                      ],
                    ),
                  ),
                  w10,
                  AddToCartButton(
                    productId: widget.productId,
                  ),
                ],
              ),
            ),

            // Removed the separate row for AddToCartButton
            // Added bottom padding for better spacing
          ],
        ),
      ),
    );
  }
}

class Review extends StatelessWidget {
  const Review({
    super.key,
    required this.widget,
  });

  final ProductCard widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 16.sp,
          ),
          const SizedBox(width: 2),
          Text(
            widget.rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade700,
            ),
          ),
        ],
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
  Timer? _resetTimer;

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          await addToCartCubit
              .addToCart(
            context: context,
            productId: widget.productId,
          )
              .then((_) {
            CartItemsCubit.of(context).addCartItems();

            if (!mounted) return; // Check if still mounted before setState
            setState(() {
              _isAdded = true;
            });

            // Cancel any existing timer
            _resetTimer?.cancel();

            // Create a new timer and store the reference
            _resetTimer = Timer(const Duration(seconds: 2), () {
              if (mounted) {
                // Check if still mounted before setState
                setState(() {
                  _isAdded = false;
                });
              }
            });
          });
        },
        child: Container(
          height: 30,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _isAdded
                ? Colors.green // Change color when added if desired
                : AppColors.primaryColor,
          ),
          child: _isAdded
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                ) // Replace with your check icon
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FittedBox(
                    child: Text(
                      'Add to cart'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class HorizontalProductCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String price;
  final String? discountPercentage;
  final String description;
  final double rating;
  final Function(bool isNowLiked)? onLikeTap;
  final int productId;
  final bool initialLiked;

  const HorizontalProductCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.price,
    this.discountPercentage,
    this.description = 'No description available',
    this.rating = 0.0,
    this.onLikeTap,
    required this.initialLiked,
    required this.productId,
  }) : super(key: key);

  @override
  State<HorizontalProductCard> createState() => _HorizontalProductCardState();
}

class _HorizontalProductCardState extends State<HorizontalProductCard> {
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
    // Fixed height to prevent overflow
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
        height: 130, // Fixed height
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.grey.withOpacity(0.3),
          // ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to fill height
          children: [
            // Left side - Product image with like button
            AspectRatio(
              aspectRatio: 1, // Square image
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(9),
                      bottomLeft: Radius.circular(9),
                    ),
                    child: CacheImage(
                      urlImage: widget.imagePath,
                      errorColor: Colors.grey,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
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
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Right side - Product information
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and rating - limited height
                    Expanded(
                      flex: 5, // Title and rating take 3/10 of the space
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style:  TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                widget.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Description - limited height
                    Expanded(
                      flex: 4, // Description takes 4/10 of the space
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Price and add to cart button - limited height
                    Expanded(
                      flex: 3, // Price and button take 3/10 of the space
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                Text(
                                  widget.price,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                w5,
                                SvgPicture.asset(
                                  AppIcons.currency,
                                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                  height: 14,
                                  width: 14,
                                ),
                              ],
                            ),
                          ),
                          w10,
                          HorizontalAddToCartButton(
                            productId: widget.productId,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalAddToCartButton extends StatefulWidget {
  const HorizontalAddToCartButton({
    super.key,
    required this.productId,
  });

  final int productId;

  @override
  State<HorizontalAddToCartButton> createState() => _HorizontalAddToCartButtonState();
}

class _HorizontalAddToCartButtonState extends State<HorizontalAddToCartButton> {
  AddToCartCubit addToCartCubit = AddToCartCubit();
  bool _isAdded = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          await addToCartCubit
              .addToCart(
            context: context,
            productId: widget.productId,
          )
              .then((_) {
            CartItemsCubit.of(context).addCartItems();

            if (!mounted) return;
            setState(() {
              _isAdded = true;
            });

            _resetTimer?.cancel();
            _resetTimer = Timer(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _isAdded = false;
                });
              }
            });
          });
        },
        child: Container(
          height: 30,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _isAdded ? Colors.green : AppColors.primaryColor,
          ),
          child: _isAdded
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FittedBox(
                    child: Text(
                      'Add to cart'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
