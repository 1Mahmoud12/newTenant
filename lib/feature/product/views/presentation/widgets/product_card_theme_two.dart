import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/feature/cart/view/manager/addToCart/cubit/add_to_cart_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/manager/cartItems/cubit/cart_items_cubit.dart';
import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCardThemeTwo extends StatefulWidget {
  final String imagePath;
  final String title;
  final String? skuCode;
  final String price;
  final String description;
  final double rating;
  final int productId;
  final bool initialLiked;
  final Function(bool) onLikeTap;
  final bool useStaggered;
  final List<Variants> sku;

  const ProductCardThemeTwo({
    Key? key,
    required this.imagePath,
    required this.title,
    this.skuCode,
    required this.price,
    required this.description,
    required this.rating,
    required this.productId,
    required this.initialLiked,
    required this.onLikeTap,
    this.useStaggered = false,
    required this.sku,
  }) : super(key: key);

  @override
  State<ProductCardThemeTwo> createState() => _ProductCardThemeTwoState();
}

class _ProductCardThemeTwoState extends State<ProductCardThemeTwo> {
  AddToCartCubit addToCartCubit = AddToCartCubit();
  bool isAddedToCart = false;

  void toggleLike() {
    widget.onLikeTap.call(context.read<WishListCubit>().isWishListed(productId: widget.productId));
    debugPrint('Liked:  for ${widget.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Like Button
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: widget.useStaggered ? 1 : 1.2,
                  child: Image.network(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
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
                        context.watch<WishListCubit>().isWishListed(productId: widget.productId) ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Product Information
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      //customShowToast(context, 'need_edit');
                      CartItemsCubit.of(context).addCartItems();
                      await addToCartCubit.addToCart(
                        context: context, productId: widget.productId, variantId: widget.sku.firstOrNull?.id ?? 0,
                        //  sizeCode: '',
                      );
                      setState(() {
                        isAddedToCart = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          w10,
                          Text(
                            widget.price,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          s,
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isAddedToCart ? Colors.green : AppColors.primaryColor,
                              // borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                isAddedToCart ? Icons.done : Icons.add,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
