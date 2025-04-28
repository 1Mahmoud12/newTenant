import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/see_all_widget.dart';
import 'package:dobzz_seller/core/utils/app_images.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/Categories/presentation/Categories_veiw.dart';
import 'package:dobzz_seller/feature/home/data/models/sales_model.dart';
import 'package:dobzz_seller/feature/home/views/manager/salesBanner/cubit/sales_banner_cubit.dart';
import 'package:dobzz_seller/feature/home/views/presentation/search_product_home_view.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/categories_list.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/flash_sale_gride.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/home_page_header.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/home_slider.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/horizotal_product_list.dart';
import 'package:dobzz_seller/feature/home/views/presentation/widgets/sale_widget.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    if (ConstantsModels.salesBannerModel == null) {
      salesBannerCubit.getSaleBanner(context: context);
    }
    super.initState();
  }

  SalesBannerCubit salesBannerCubit = SalesBannerCubit();
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
                      hintText: 'Search product..'.tr(),
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
                    title: 'Categories'.tr(),
                    onTap: () {
                      context.navigateToPage(const CategoriesScreen());
                    },
                  ),
                ),
                h10,
                const CategoriesList(),
                h10,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: SeeAllWidget(
                    title: 'Our Bestseller'.tr(),
                    onTap: () {
                      context.navigateToPage(const ProductView());
                    },
                  ),
                ),
                const FlashSaleHorizontalList(),
                h10,
                BlocProvider.value(
                  value: salesBannerCubit,
                  child: BlocBuilder<SalesBannerCubit, SalesBannerState>(
                    builder: (context, state) {
                      return SaleCountdownBanner(
                        bannerData: ConstantsModels.salesBannerModel?.data ?? SaleBannerData(),
                        onActionPressed: () {
                          context.navigateToPage(const ProductView());
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: SeeAllWidget(
                    title: 'Top Product'.tr(),
                    onTap: () {
                      context.navigateToPage(const ProductView());
                    },
                  ),
                ),
                const FlashSaleHorizontalList(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: SeeAllWidget(
                    title: 'New Arrival'.tr(),
                    onTap: () {
                      context.navigateToPage(const ProductView());
                    },
                  ),
                ),
                const FlashSaleHorizontalList(),
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
