import 'package:flutter/material.dart';
import 'flash_card.dart'; // Make sure to import the FlashCard widget

class FlashSaleGrid extends StatelessWidget {
  const FlashSaleGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> flashItems = [
      {
        'imagePath': 'assets/images/product1.jpg',
        'title': 'Sneakers',
        'price': '\$99',
      },
      {
        'imagePath': 'assets/images/product2.jpg',
        'title': 'Watch',
        'price': '\$199',
        'discount': '30%',
      },
      {
        'imagePath': 'assets/images/product3.jpg',
        'title': 'Headphones',
        'price': '\$79',
        'discount': '15%',
      },
      {
        'imagePath': 'assets/images/product4.jpg',
        'title': 'Sunglasses',
        'price': '\$49',
      },
    ];

    return GridView.builder(
      itemCount: flashItems.length,

      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final item = flashItems[index];
        return FlashCard(
          onLikeTap: (isNowLiked) {},
          imagePath: item['imagePath']!,
          title: item['title']!,
          price: item['price']!,
          discountPercentage: item['discount'],
        );
      },
    );
  }
}
