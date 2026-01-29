import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/feature/home/data/models/categories_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CategoryTabs extends StatelessWidget {
  final List<CategoryData> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategoryTap;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildCategoryChip(
              context: context,
              label: 'All'.tr(),
              isSelected: selectedCategoryId == null,
              onTap: () => onCategoryTap(null),
            ),
            const SizedBox(width: 8),
            ...categories.map((category) {
              final categoryId = category.id is int ? category.id : (category.id as num?)?.toInt();
              final categoryName = category.name?.toString() ?? '';

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildCategoryChip(
                  context: context,
                  label: categoryName,
                  isSelected: categoryId == selectedCategoryId,
                  onTap: () => onCategoryTap(categoryId),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: FittedBox(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
