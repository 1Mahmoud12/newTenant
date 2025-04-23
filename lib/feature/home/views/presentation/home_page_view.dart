import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/see_all_widget.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/Categories/presentation/Categories_veiw.dart';
import 'package:dobzz_seller/feature/home/views/presentation/search_product_home_view.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/categories_list.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/flash_sale_gride.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/home_page_header.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/home_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20), // prevent clipping at bottom
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h20,
                const HomePageHeader(),
                h10,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      context.navigateToPage(const SearchProductHomeView());
                    },
                    child: CustomTextFormField(
                      prefixIcon: const Icon(Icons.search),
                      enable: false,
                      controller: TextEditingController(),
                      hintText: 'Search product..',
                      outPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                h10,
                const HomeSlider(),
                h10,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SeeAllWidget(
                    title: 'Categories',
                    onTap: () {
                      context.navigateToPage(const CategoriesScreen());
                    },
                  ),
                ),
                h10,
                const CategoriesList(),
                h10,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Flash Sale',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                h10,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: FlashSaleGrid(),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
