import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({Key? key}) : super(key: key);

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  String selectedSize = 'M';
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: const [
        PriceAndAddToCartWidget(),
      ],
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductGallery(controller: controller),
            const SizedBox(height: 16),
            Text(
              'Regular Fit Slogan',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '4.0/5',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.0, // Reduce line height
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 0), // Just to be explicit
                      Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(45 reviews)',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'The name says it all, the right size slightly snugs the body leaving enough room for comfort in the sleeves and waist.',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'Choose size',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizeSelector(
              onSelectSize: (selectedSize) {},
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProductGallery extends StatelessWidget {
  const ProductGallery({
    super.key,
    required this.controller,
  });

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.5,
          width: MediaQuery.sizeOf(context).width,
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
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.primaryColor,
                  dotColor: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PriceAndAddToCartWidget extends StatelessWidget {
  const PriceAndAddToCartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              Text(
                r'$ 1,190',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          w30,
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SizeSelector extends StatefulWidget {
  final Function(String) onSelectSize;

  const SizeSelector({
    Key? key,
    required this.onSelectSize,
  }) : super(key: key);

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  String _selectedSize = 'M'; // Default selected size

  @override
  Widget build(BuildContext context) {
    final sizes = ['S', 'M', 'L'];

    return Row(
      children: sizes.map((size) {
        final isSelected = _selectedSize == size;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedSize = size;
            });
            widget.onSelectSize(size); // Call parent callback
          },
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.black : Colors.white,
            ),
            child: Center(
              child: Text(
                size,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
