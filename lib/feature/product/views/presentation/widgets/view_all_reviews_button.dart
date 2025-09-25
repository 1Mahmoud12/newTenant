import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/feature/home/data/models/product_mdoel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Customer Reviews Section
class CustomerReviewsSection extends StatelessWidget {
  const CustomerReviewsSection({Key? key, required this.productModelData}) : super(key: key);
  final Product productModelData;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'reviews_&_ratings'.tr(),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      productModelData.averageRating.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(
            (productModelData.reviews?.length ?? 0) > 3 ? 3 : productModelData.reviews?.length ?? 0,
            (index) => CustomerReviewItem(
              reviewModel: productModelData.reviews![index],
            ),
          ),
          const SizedBox(height: 16),
          if ((productModelData.reviews?.length ?? 0) > 1)
            ViewAllReviewsButton(
              productModelData: productModelData,
            ),
        ],
      ),
    );
  }
}

// Customer Review Item Widget
class CustomerReviewItem extends StatelessWidget {
  const CustomerReviewItem({Key? key, required this.reviewModel}) : super(key: key);
  final Reviews reviewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.cBorderDecoration,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CacheImage(
                height: 56,
                width: 56,
                circle: true,
                urlImage: reviewModel.customerImage,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewModel.customer ?? Constants.unKnownValue,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('dd/MM/yyyy').format(DateTime.parse(reviewModel.createdAt.toString())),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    StarRatingWidget(rating: int.parse(reviewModel.rating.toString())),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reviewModel.review ?? Constants.unKnownValue,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w300, color: AppColors.grey3Color),
          ),
        ],
      ),
    );
  }
}

// Star Rating Widget
class StarRatingWidget extends StatelessWidget {
  final int rating;

  const StarRatingWidget({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: AppColors.amber,
        );
      }),
    );
  }
}

// View All Reviews Button
class ViewAllReviewsButton extends StatelessWidget {
  const ViewAllReviewsButton({Key? key, required this.productModelData}) : super(key: key);
  final Product productModelData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomTextButton(
        backgroundColor: Colors.transparent,
        borderColor: AppColors.primaryColor,
        borderRadius: 20,
        colorText: AppColors.black,
        onPress: () {
          // context.navigateToPage(
          //   ReviewsView(productId: productModelData.id ?? 0),
          // );
        },
        childText: 'view_all_reviews',
      ),
    );
  }
}
