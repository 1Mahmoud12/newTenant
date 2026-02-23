import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rova_star/core/component/custom_app_bar.dart';
import 'package:rova_star/feature/home/views/presentation/widgets/cart_floating_action_button.dart';
import 'package:rova_star/feature/home/views/presentation/widgets/flash_sale_gride.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CartFloatingAB(),
      appBar: customAppBar(context: context, title: 'Saved items'.tr(), stopLeading: true),
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
