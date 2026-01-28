import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Reusable wishlist icon button with loading state
///
/// Usage:
/// ```dart
/// WishlistIconButton(
///   productId: product.id!,
///   size: 18,
///   backgroundColor: Colors.black87,
/// )
/// ```
class WishlistIconButton extends StatefulWidget {
  final int productId;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final EdgeInsets padding;
  final VoidCallback? onToggled;

  const WishlistIconButton({
    Key? key,
    required this.productId,
    this.size = 18,
    this.backgroundColor = Colors.black87,
    this.iconColor = Colors.white,
    this.padding = const EdgeInsets.all(6),
    this.onToggled,
  }) : super(key: key);

  @override
  State<WishlistIconButton> createState() => _WishlistIconButtonState();
}

class _WishlistIconButtonState extends State<WishlistIconButton> {
  bool _isLoading = false;

  Future<void> _toggleWishlist() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final cubit = context.read<WishListCubit>();
    final isCurrentlyWishlisted = cubit.isWishListed(productId: widget.productId);

    try {
      if (isCurrentlyWishlisted) {
        await cubit.removeFromWishList(
          context: context,
          productId: widget.productId,
        );
      } else {
        await cubit.addToWishList(
          context: context,
          productId: widget.productId,
        );
      }

      widget.onToggled?.call();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleWishlist,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: _isLoading
            ? SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.iconColor),
                ),
              )
            : Icon(
                context.watch<WishListCubit>().isWishListed(productId: widget.productId) ? Icons.favorite : Icons.favorite_border,
                color: widget.iconColor,
                size: widget.size,
              ),
      ),
    );
  }
}
