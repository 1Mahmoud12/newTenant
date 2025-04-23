import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/Categories/presentation/Categories_veiw.dart';
import 'package:dobzz_seller/feature/Categories/presentation/sub_category_view.dart';
import 'package:dobzz_seller/feature/home/views/manager/categories/cubit/categories_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  late CategoriesCubit _categoriesCubit;

  @override
  void initState() {
    super.initState();
    _categoriesCubit = CategoriesCubit();
    if (ConstantsModels.categoriesModel == null) {
      _categoriesCubit.getCategories(context: context);
    }
  }

  @override
  void dispose() {
    _categoriesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _categoriesCubit,
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const Center(child: LoadingWidget());
          } else if (state is CategoriesError) {
            return Center(child: Text('Error: ${state.e}'));
          } else if (ConstantsModels.categoriesModel != null) {
            // Get the categories from your model
            final categories = ConstantsModels.categoriesModel?.data ?? [];

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: List.generate(
                    categories.isNotEmpty ? categories.length : 6,
                    (index) {
                      // If we have real data, use it, otherwise fallback to placeholder
                      final name = categories.isNotEmpty ? categories[index].name ?? 'Category' : 'T-shirt';

                      return InkWell(
                        onTap: () {
                          context.navigateToPage(
                            SubcategoryScreen(
                              categoryId: categories[index].id ?? 0,
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            right: context.locale.languageCode == 'ar' ? 0 : 8,
                            left: context.locale.languageCode == 'en' ? 0 : 8,
                          ),
                          width: 60,
                          child: Column(
                            children: [
                              CacheImage(
                                urlImage: categories.isNotEmpty ? categories[index].imagePath ?? AppIcons.tShirtCate : AppIcons.tShirtCate,
                                width: 60,
                                height: 60,
                              ),
                              h5,
                              Text(
                                name.tr(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }

          // Default fallback UI
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(6, (index) {
                  return Container(
                    margin: EdgeInsets.only(
                      right: context.locale.languageCode == 'ar' ? 0 : 8,
                      left: context.locale.languageCode == 'en' ? 0 : 8,
                    ),
                    width: 60,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade300,
                          ),
                          child: SvgPicture.asset(AppIcons.tShirtCate),
                        ),
                        h5,
                        Text(
                          'T-shirt'.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
