import 'package:rova_star/core/component/cache_image.dart';
import 'package:rova_star/core/component/custom_app_bar.dart';
import 'package:rova_star/core/component/fields/custom_text_form_field.dart';
import 'package:rova_star/core/component/loadsErros/loading_widget.dart';
import 'package:rova_star/core/utils/constants.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:rova_star/core/utils/navigate.dart';
import 'package:rova_star/feature/home/data/models/product_mdoel.dart';
import 'package:rova_star/feature/home/views/manager/topProduct/cubit/top_product_cubit.dart';
import 'package:rova_star/feature/product/views/presentation/product_details_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchProductHomeView extends StatefulWidget {
  const SearchProductHomeView({Key? key}) : super(key: key);

  @override
  _SearchProductHomeViewState createState() => _SearchProductHomeViewState();
}

class _SearchProductHomeViewState extends State<SearchProductHomeView> {
  final TextEditingController _searchController = TextEditingController();

  TopProductCubit topProductCubit = TopProductCubit();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Search'.tr()),
      body: Column(
        children: [
          CustomTextFormField(
            controller: _searchController,
            hintText: 'Search for clothes...'.tr(),
            prefixIcon: const Icon(Icons.search),
            onChange: (value) {
              if (value.isNotEmpty) {
                topProductCubit.getTopProduct(context: context, searchProductByName: value);
              } else {
                ConstantsModels.searchProductsModel = null;
                setState(() {});
              }
            },
          ),
          Expanded(
            child: BlocProvider.value(
              value: topProductCubit,
              child: BlocBuilder<TopProductCubit, TopProductState>(
                builder: (context, state) {
                  return _buildProductsList(state);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(TopProductState state) {
    if (state is TopProductLoading) {
      return const Center(child: LoadingWidget());
    }
    if (state is TopProductError) {
      return Center(child: Text('${'Error:'.tr()}${state.e}'));
    }
    if (ConstantsModels.searchProductsModel?.data?.isEmpty ?? true) {
      return EmptyWidget(
        data: 'No Results Found!'.tr(),
        subData: 'Try a similar word or something more general.'.tr(),
        emptyImage: EmptyImages.noSearchResult,
      );
    }
    if (state is TopProductSuccess) {
      final products = ConstantsModels.searchProductsModel?.data ?? [];
      if (products.isEmpty) {
        return EmptyWidget(
          data: 'No Results Found!'.tr(),
          subData: 'Try a similar word or something more general.'.tr(),
          emptyImage: EmptyImages.noSearchResult,
        );
      }
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return SearchedProductCard(product: product);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class SearchedProductCard extends StatelessWidget {
  const SearchedProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CacheImage(
        urlImage: product.imagePath ?? '',
        errorColor: Colors.grey,
        height: 60,
        width: 60,
        fit: BoxFit.cover,
      ),
      title: Text(
        product.name ?? '',
        style: TextStyle(fontSize: Constants.tablet ? 16 : 16.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Text(
            '\$${product.price?.toStringAsFixed(2)}',
            style: TextStyle(fontSize: Constants.tablet ? 14 : 14.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_outward),
      onTap: () {
        // context.navigateToPage(
        //   ProductDetailsView(
        //     productId: product.id ?? -1,
        //     variants: product.variants ?? [],
        //   ),
        // );
        context.navigateToPage(
          ProductDetailsView(
            variants: product.variants ?? [],
            productId: product.id!,
          ),
        );
      },
    );
  }
}
