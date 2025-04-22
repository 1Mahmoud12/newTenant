import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/cart/view/manager/addToCart/cubit/add_to_cart_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/addToWhishlist/cubit/add_to_wish_list_cubit.dart';
import 'package:dobzz_seller/feature/home/views/manager/removeFromWhislist/cubit/remove_from_whish_list_cubit.dart';
import 'package:dobzz_seller/feature/product/views/manager/productDetails/cubit/product_details_cubit.dart';
import 'package:dobzz_seller/feature/review/presentation/review_veiw.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsView extends StatefulWidget {
  final int productId;
  final bool? initialLiked;
  const ProductDetailsView({
    Key? key,
    required this.productId,
    this.initialLiked = false,
  }) : super(key: key);

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  String selectedSize = 'M';
  final PageController controller = PageController();
  final AddToCartCubit addToCartCubit = AddToCartCubit();
  final ProductDetailsCubit productDetailsCubit = ProductDetailsCubit();
  AddToWishListCubit addToWishListCubit = AddToWishListCubit();
  RemoveFromWhishListCubit removeFromWhishListCubit = RemoveFromWhishListCubit();
  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  void _loadProductDetails() {
    productDetailsCubit.getProductDetailsData(
      context: context,
      productId: widget.productId,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => productDetailsCubit),
        BlocProvider(create: (context) => addToCartCubit),
      ],
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state is ProductDetailsError) {
            // return Text(data: state.e.toString());
          }
        },
        builder: (context, state) {
          return Scaffold(
            persistentFooterButtons: [
              if (state is ProductDetailsSuccess)
                PriceAndAddToCartWidget(
                  price: ConstantsModels.productDetailsModel?.data?.price ?? 0,
                  addToCartCubit: addToCartCubit,
                  productId: widget.productId,
                )
              else
                const SizedBox(height: 56),
            ],
            appBar: customAppBar(context: context, title: 'Product Details'),
            body: _buildBody(state, productId: widget.productId),
          );
        },
      ),
    );
  }

  Widget _buildBody(ProductDetailsState state, {required int productId}) {
    if (state is ProductDetailsLoading) {
      return const Center(child: LoadingWidget());
    } else if (state is ProductDetailsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.e}'),
            const SizedBox(height: 16),
            CustomTextButton(
              onPress: _loadProductDetails,
              childText: 'Retry',
            ),
          ],
        ),
      );
    } else if (state is ProductDetailsSuccess) {
      final productDetails = ConstantsModels.productDetailsModel?.data;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductGallery(
              initialLiked: widget.initialLiked,
              onLikeTap: (isNowLiked) {
                if (isNowLiked) {
                  addToWishListCubit.addToWishList(context: context, productId: productId);
                }
              },
              controller: controller,
              images: [productDetails?.imagePath ?? ''],
            ),
            const SizedBox(height: 16),
            ProductTitle(productName: productDetails?.name ?? ''),
            RatingAndReview(
              rating: productDetails?.reviewsCount.toString() ?? '0',
              reviewCount: productDetails?.reviews?.length ?? 0,
              onTap: () {
                context.navigateToPage(
                  const ReviewsView(

                      // productId: widget.productId

                      ),
                );
              },
            ),
            const SizedBox(height: 12),
            ProductDescription(description: productDetails?.description ?? ''),
            // if (productDetails?.sizes?.isNotEmpty ?? false)
            //   SizeSelectorSection(
            //     sizes: productDetails!.sizes!,
            //     selectedSize: selectedSize,
            //     onSelectSize: (value) {
            //       setState(() => selectedSize = value);
            //     },
            //   ),
            QuantitySelector(
              addToCartCubit: addToCartCubit,
              quantity: addToCartCubit.quantity,
              onIncrease: () => setState(() => addToCartCubit.quantity++),
              onDecrease: () {
                if (addToCartCubit.quantity > 1) {
                  setState(() => addToCartCubit.quantity--);
                }
              },
            ),
          ],
        ),
      );
    }

    // Initial state or any other state
    return const Center(child: Text('Loading product details...'));
  }
}

class ProductTitle extends StatelessWidget {
  const ProductTitle({super.key, required this.productName});
  final String productName;
  @override
  Widget build(BuildContext context) {
    return Text(
      productName,
      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
    );
  }
}

class RatingAndReview extends StatelessWidget {
  final VoidCallback onTap;
  final String rating;
  final int reviewCount;
  const RatingAndReview({required this.onTap, super.key, required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.orange, size: 20),
        const SizedBox(width: 4),
        IntrinsicWidth(
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rating,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, height: 1),
                ),
                Container(height: 1, color: Colors.black),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($reviewCount reviews)',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }
}

class ProductDescription extends StatelessWidget {
  const ProductDescription({super.key, required this.description});
  final String description;
  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.grey),
    );
  }
}

class SizeSelectorSection extends StatelessWidget {
  final String selectedSize;
  final ValueChanged<String> onSelectSize;

  const SizeSelectorSection({
    required this.selectedSize,
    required this.onSelectSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose size', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizeSelector(onSelectSize: onSelectSize),
      ],
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final AddToCartCubit addToCartCubit;
  const QuantitySelector({
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    super.key,
    required this.addToCartCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onDecrease,
                icon: const Icon(Icons.remove),
              ),
              Text('${addToCartCubit.quantity}', style: TextStyle(fontSize: 16.sp)),
              IconButton(
                onPressed: onIncrease,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductGallery extends StatefulWidget {
  const ProductGallery({
    super.key,
    required this.controller,
    required this.images,
    this.onLikeTap,
    this.initialLiked = false,
  });
  final List<String> images;
  final PageController controller;
  final Function(bool isNowLiked)? onLikeTap;
  final bool? initialLiked;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  @override
  void initState() {
    isLiked = widget.initialLiked!;
    super.initState();
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    widget.onLikeTap?.call(isLiked);
  }

  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.5,
          width: MediaQuery.sizeOf(context).width,
          child: PageView(
            controller: widget.controller,
            children: List.generate(
              widget.images.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  right: context.locale.languageCode == 'ar' ? 0 : 5,
                  left: context.locale.languageCode == 'ar' ? 5 : 0,
                ),
                child: CacheImage(
                  urlImage: widget.images[index],
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
                controller: widget.controller,
                count: widget.images.length,
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
            onTap: toggleLike,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
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

class PriceAndAddToCartWidget extends StatefulWidget {
  const PriceAndAddToCartWidget({
    super.key,
    required this.addToCartCubit,
    required this.price,
    required this.productId,
  });
  final AddToCartCubit addToCartCubit;
  final num price;
  final int productId;
  @override
  State<PriceAndAddToCartWidget> createState() => _PriceAndAddToCartWidgetState();
}

class _PriceAndAddToCartWidgetState extends State<PriceAndAddToCartWidget> {
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
                '${widget.price} EGP',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          w30,
          Expanded(
            child: BlocProvider.value(
              value: widget.addToCartCubit,
              child: BlocBuilder<AddToCartCubit, AddToCartState>(
                builder: (context, state) {
                  return CustomTextButton(
                    child: state is AddToCartLoading
                        ? const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              s,
                              const Icon(Icons.shopping_cart, color: Colors.white),
                              Text(
                                'Add to Cart',
                                style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                              ),
                              s,
                            ],
                          ),
                    onPress: () {
                      widget.addToCartCubit.addToCart(context: context, productId: widget.productId);
                    },
                  );
                },
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
