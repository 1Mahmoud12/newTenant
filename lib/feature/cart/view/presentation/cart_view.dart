import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<CartItem> cartItems = [
    CartItem(
      imageUrl: 'https://example.com/image.jpg',
      title: 'Product 1',
      size: 'L',
      price: '\$29.99',
      quantity: 2,
    ),
    CartItem(
      imageUrl: 'https://example.com/image.jpg',
      title: 'Product 2',
      size: 'M',
      price: '\$19.99',
      quantity: 1,
    ),
    CartItem(
      imageUrl: 'https://example.com/image.jpg',
      title: 'Product 2',
      size: 'M',
      price: '\$19.99',
      quantity: 1,
    ),
    CartItem(
      imageUrl: 'https://example.com/image.jpg',
      title: 'Product 2',
      size: 'M',
      price: '\$19.99',
      quantity: 1,
    ),
    CartItem(
      imageUrl: 'https://example.com/image.jpg',
      title: 'Product 2',
      size: 'M',
      price: '\$19.99',
      quantity: 1,
    ),
  ];

  // Handle add quantity
  void onAdd(CartItem item) {
    setState(() {
      item.quantity += 1;
    });
  }

  // Handle remove quantity
  void onRemove(CartItem item) {
    if (item.quantity > 1) {
      setState(() {
        item.quantity -= 1;
      });
    }
  }

  // Handle item delete
  void onDelete(CartItem item) {
    setState(() {
      cartItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const CheckOutItem(
                label: 'Sub-total',
                value: '8452.5',
              ),
              const CheckOutItem(
                label: 'VAT(%)',
                value: '8452.5',
              ),
              const CheckOutItem(
                label: 'Shipping fee',
                value: '8452.5',
              ),
              Divider(
                thickness: 0.7,
                color: Colors.grey.withOpacity(0.5),
              ),
              const CheckOutItem(
                label: 'Total',
                value: '8452.5',
                labelColor: Colors.black,
              ),
              h20,
              CustomTextButton(
                borderRadius: 8,
                onPress: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      'Go To Check out',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    w10,
                    const Icon(Icons.arrow_forward, color: Colors.white),
                    s,
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      appBar: customAppBar(context: context, title: 'Cart'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Loop through the cart items list to create CartItemWidget for each
              for (final item in cartItems)
                CartItemWidget(
                  cartItem: item,
                  onRemove: () => onRemove(item),
                  onAdd: () => onAdd(item),
                  onDelete: () => onDelete(item),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckOutItem extends StatelessWidget {
  const CheckOutItem({
    super.key,
    required this.label,
    required this.value,
    this.labelColor,
  });
  final String label;
  final String value;
  final Color? labelColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, color: labelColor ?? Colors.grey.shade400),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String imageUrl;
  final String title;
  final String size;
  final String price;
  int quantity; // Quantity is now mutable (can be updated)

  CartItem({
    required this.imageUrl,
    required this.title,
    required this.size,
    required this.price,
    required this.quantity,
  });
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            const CacheImage(
              urlImage: '',
              errorColor: Colors.grey,
              width: 100,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cartItem.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(Icons.delete_outline, color: Colors.red, size: 20.sp),
                      ),
                    ],
                  ),
                  Text(
                    'Size ${cartItem.size}',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        cartItem.price,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _QuantityButton(
                        icon: Icons.remove,
                        onTap: onRemove,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cartItem.quantity.toString(),
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      const SizedBox(width: 8),
                      _QuantityButton(
                        icon: Icons.add,
                        onTap: onAdd,
                      ),
                    ],
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

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(icon, size: 18.sp),
      ),
    );
  }
}
