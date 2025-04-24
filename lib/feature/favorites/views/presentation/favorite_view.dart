import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/flash_sale_gride.dart';
import 'package:flutter/material.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Saved items', stopLeading: true),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(child: FlashSaleGrid(isItWhishList: true)),
            SizedBox(
              height: 90,
            ),
          ],
        ),
      ),
    );
  }
}
