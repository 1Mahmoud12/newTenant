import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/services/payment/manager/payment_cubit.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/app_images.dart';
import 'package:dobzz_seller/core/utils/bottomSheet/failure_bottom_sheet_with_reason.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum EnumPaymentMethod {
  cash,
  invoice,
  stc,
}

class PaymentModel {
  final String title;
  final String image;
  final int id;

  PaymentModel({required this.title, required this.image, required this.id});
}

Future<PaymentModel> selectPaymentMethodDialog(
  BuildContext context, {
  required Function(String paymentMethodName) onPress,
  required bool createOrder,
}) async {
  final PaymentCubit cubit = PaymentCubit();
  cubit.getAllPaymentMethod();
  PaymentModel paymentModel = PaymentModel(
    title: Constants.unKnownValue,
    image: '',
    id: -1,
  );
  // final cubit = PaymentCubit();
  List<PaymentModel> payments = [
    PaymentModel(
      title: EnumPaymentMethod.cash.name,
      image: AppIcons.cashIc,
      id: 1,
    ),
  ];
  if (ConstantsModels.paymentMethodModel?.data?.isNotEmpty ?? false) {
    ConstantsModels.paymentMethodModel?.data?[0].allowedPaymentMethods?.forEach((element) {
      payments.add(
        PaymentModel(
          title: element,
          image: element == EnumPaymentMethod.invoice.name ? AppImages.moyassar : AppIcons.stcPay,
          id: element.hashCode,
        ),
      );
    });
  }
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
                const SizedBox(height: 12),
                BlocProvider.value(
                  value: cubit,
                  child: BlocBuilder<PaymentCubit, PaymentState>(
                    builder: (context, state) {
                      payments = [
                        PaymentModel(
                          title: EnumPaymentMethod.cash.name,
                          image: AppIcons.cashIc,
                          id: 1,
                        ),
                      ];
                      if (ConstantsModels.paymentMethodModel?.data?.isNotEmpty ?? false) {
                        ConstantsModels.paymentMethodModel?.data?[0].allowedPaymentMethods?.forEach((element) {
                          payments.add(
                            PaymentModel(
                              title: element,
                              image: element == EnumPaymentMethod.invoice.name ? AppImages.moyassar : AppIcons.stcPay,
                              id: element.hashCode,
                            ),
                          );
                        });
                      }

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
                                    SizedBox(
                                      width: 30,
                                      child: payments[index].image.contains('svg')
                                          ? SvgPicture.asset(
                                              payments[index].image,
                                              width: 30,
                                              height: 20,
                                            )
                                          : Image.asset(
                                              payments[index].image,
                                              width: 30,
                                              height: 20,
                                            ),
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
                                    const Spacer(),
                                    if (payments[index].title == EnumPaymentMethod.invoice.name) ...[
                                      SvgPicture.asset(
                                        AppIcons.visa,
                                        width: 10,
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      SvgPicture.asset(
                                        AppIcons.creditCard,
                                        width: 10,
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      SvgPicture.asset(
                                        AppIcons.mada,
                                        width: 10,
                                        height: 10,
                                      ),
                                    ],
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
                      failureModalBottomSheetWithReason(
                        context,
                        reasons: [
                          'you_must_select_payment'.tr(),
                        ],
                        onPress: () {},
                      );
                      // Utils.showToast(title: 'you_must_select_payment'.tr(), state: UtilState.warning);
                      return;
                    }
                    //  Navigator.pop(context);
                    if (createOrder) cubit.createOrder(context: context, paymentMethod: paymentModel.title);
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
