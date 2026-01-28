import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
// import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';
import 'package:dobzz_seller/feature/home/views/manager/search/cubit/search_cubit.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_details_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchProductHomeView extends StatefulWidget {
  const SearchProductHomeView({Key? key}) : super(key: key);

  @override
  _SearchProductHomeViewState createState() => _SearchProductHomeViewState();
}

class _SearchProductHomeViewState extends State<SearchProductHomeView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SearchCubit searchCubit = SearchCubit();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      searchCubit.loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    searchCubit.close();
    super.dispose();
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
              // Debounce could be added here if needed, but for now calling directly
              searchCubit.searchProducts(name: value);
            },
          ),
          Expanded(
            child: BlocProvider.value(
              value: searchCubit,
              child: BlocBuilder<SearchCubit, SearchState>(
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

  Widget _buildProductsList(SearchState state) {
    if (state is SearchLoading && searchCubit.products.isEmpty) {
      return Skeletonizer(
        effect: ShimmerEffect(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
        ),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return SearchedProductCard(
              product: Product(
                name: 'Product Name',
                price: 100,
                coverImageUrl: '',
              ),
            );
          },
        ),
      );
    }
    if (state is SearchError && searchCubit.products.isEmpty) {
      return Center(
        child: EmptyWidget(
          data: '${'Error:'.tr()}${state.e}',
          emptyImage: EmptyImages.anErrorOccurred, // Assuming error image exists or use default
          onTap: () {
            searchCubit.searchProducts(name: _searchController.text);
          },
        ),
      );
    }

    final products = searchCubit.products;

    if (products.isEmpty) {
      if (state is SearchInitial) {
        // Initial state (empty query
        return const SizedBox.shrink(); // Or show a "Start searching" message
      }
      // Search executed but no results
      return EmptyWidget(
        data: 'No Results Found!'.tr(),
        subData: 'Try a similar word or something more general.'.tr(),
        emptyImage: EmptyImages.noSearchResult,
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: products.length + (searchCubit.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: LoadingWidget(),
          ));
        }
        final product = products[index];
        return SearchedProductCard(product: product);
      },
    );
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
      leading: Skeleton.leaf(
        child: CacheImage(
          urlImage: product.coverImageUrl ?? '',
          errorColor: Colors.grey,
          height: 60,
          width: 60,
          fit: BoxFit.cover,
        ),
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
