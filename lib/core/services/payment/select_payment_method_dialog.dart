import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/services/payment/manager/payment_cubit.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/bottomSheet/failure_bottom_sheet_with_no_reason.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentModel {
  final String title;
  final String image;
  final int id;

  PaymentModel({required this.title, required this.image, required this.id});
}

Future<PaymentModel> selectPaymentMethodDialog(
  BuildContext context, {
  required int orderId,
  required Function(int paymentMethodId) onPress,
}) async {
  final PaymentCubit cubit = PaymentCubit(orderId);
  cubit.getAllPaymentMethod();
  PaymentModel paymentModel = PaymentModel(
    title: Constants.unKnownValue,
    image: '',
    id: -1,
  );
  // final cubit = PaymentCubit();
  List<PaymentModel> payments = [];
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.cCustomDividerColor),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.cCustomDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'select_payment_method'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                // Text(
                //   'there_is_an_error_in_your_card_information,_please_check_the_following'.tr(),
                //   textAlign: TextAlign.center,
                //   style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.cSecondaryBlack, fontWeight: FontWeight.w600),
                // ),
                const SizedBox(height: 12),
                BlocProvider.value(
                  value: cubit,
                  child: BlocBuilder<PaymentCubit, PaymentState>(
                    builder: (context, state) {
                      payments = [];
                      ConstantsModels.paymentMethodModel?.data?[0].allowedPaymentMethods?.forEach((element) {
                        print(element.runtimeType.hashCode);
                        payments.add(
                          PaymentModel(
                            title: element ?? Constants.unKnownValue,
                            image: '',
                            id: element.hashCode,
                          ),
                        );
                      });

                      return Column(
                        children: [
                          ...List.generate(
                            payments.length,
                            (index) => InkWell(
                              onTap: () {
                                paymentModel = payments[index];
                                setState(() {});
                              },
                              child: AnimatedContainer(
                                duration: Durations.medium1,
                                alignment: AlignmentDirectional.center,
                                padding: const EdgeInsets.all(14),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: paymentModel.id == payments[index].id ? AppColors.primaryColor : AppColors.grey, width: 2),
                                ),
                                child: Row(
                                  children: [
                                    CacheImage(
                                      urlImage: payments[index].image,
                                      width: 25,
                                      height: 25,
                                      /* colorFilter:
                                    ColorFilter.mode(paymentModel.id == payments[index].id ? AppColors.primaryColor : AppColors.b200, BlendMode.srcIn),
                            */
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      payments[index].title.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(color: AppColors.cSecondaryBlack, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),
                CustomTextButton(
                  child: Text(
                    'continue'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPress: () {
                    if (paymentModel.id == -1) {
                      //'you_must_select_payment'.tr(),
                      failureModalBottomSheetWithNoReason(
                        context,
                        onPress: () {},
                      );
                      // Utils.showToast(title: 'you_must_select_payment'.tr(), state: UtilState.warning);
                      return;
                    }
                    Navigator.pop(context);
                    onPress(paymentModel.id);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      );
    },
  );
  return paymentModel;
}
