import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/custom_list.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqsView extends StatefulWidget {
  const FaqsView({super.key});

  @override
  State<FaqsView> createState() => _FaqsViewState();
}

class _FaqsViewState extends State<FaqsView> {
  List<String> typesName = [
    'General',
    'Account',
    'Service',
    'Payment',
    'Shoes',
    'More',
  ];

  late ExpandableController expandableController1;
  late ExpandableController expandableController2;
  late ExpandableController expandableController3;
  late ExpandableController expandableController4;

  @override
  void initState() {
    super.initState();
    expandableController1 = ExpandableController();
    expandableController2 = ExpandableController();
    expandableController3 = ExpandableController();
    expandableController4 = ExpandableController();
  }

  @override
  void dispose() {
    expandableController1.dispose();
    expandableController2.dispose();
    expandableController3.dispose();
    expandableController4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'FAQs'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomList(
                  tabs: const ['General', 'Account', 'Service', 'Payment'],
                  onTabChanged: (index) {
                    //  print('Selected Tab: $index');
                    // Handle tab change logic here
                  },
                ),
              ),
              h10,
              CustomTextFormField(
                prefixIcon: const Icon(Icons.search),
                controller: TextEditingController(),
                hintText: 'Search..',
                outPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              h10,
              QuestionItem(expandableController: expandableController1),
              QuestionItem(expandableController: expandableController2),
              QuestionItem(expandableController: expandableController3),
              QuestionItem(expandableController: expandableController4),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionItem extends StatelessWidget {
  const QuestionItem({
    super.key,
    required this.expandableController,
  });

  final ExpandableController expandableController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: ExpandablePanel(
        controller: expandableController,
        header: GestureDetector(
          onTap: () {
            expandableController.toggle();
          },
          child: AnimatedBuilder(
            animation: expandableController,
            builder: (context, _) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: expandableController.expanded ? Radius.zero : const Radius.circular(8),
                    bottomRight: expandableController.expanded ? Radius.zero : const Radius.circular(8),
                    topRight: const Radius.circular(8),
                    topLeft: const Radius.circular(8),
                  ),
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    bottom: expandableController.expanded ? BorderSide.none : BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'How do I make a purchase?',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (expandableController.expanded) const Icon(Icons.keyboard_arrow_up_outlined) else const Icon(Icons.keyboard_arrow_down_sharp),
                  ],
                ),
              );
            },
          ),
        ),
        collapsed: Container(),
        expanded: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.grey.withOpacity(0.2)),
              right: BorderSide(color: Colors.grey.withOpacity(0.2)),
              bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: Column(
            children: [
              Text(
                'When you find a product you want to purchase, tap on it to view the product details. '
                'Check the price, description, and available options (if applicable), and then tap the '
                '"Add to Cart" button. Follow the on-screen instructions to complete the purchase, '
                'including providing shipping details and payment information.',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textColor),
              ),
            ],
          ),
        ),
        theme: const ExpandableThemeData(
          hasIcon: false,
        ),
      ),
    );
  }
}
