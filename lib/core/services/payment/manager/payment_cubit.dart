import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/services/payment/data/dataSource/payment_data_source.dart';
import 'package:dobzz_seller/core/services/payment/data/model/payment_credit_params.dart';
import 'package:dobzz_seller/core/services/payment/data/model/payment_stc_first_params.dart';
import 'package:dobzz_seller/core/services/payment/in_app_webView.dart';
import 'package:dobzz_seller/core/services/payment/select_payment_method_dialog.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/dialog_loading_animation.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/my_order_view.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/dataSource/process_to_checkout_data_source.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/presentation/view/widgets/add_phone_payment.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/presentation/view/widgets/show_otp.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';
import 'package:dobzz_seller/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  String addressId = Constants.defaultAddress.addressId.toString();
  PaymentDataSource paymentDataSource = PaymentDataSourceImpl();

  ProcessToCheckoutDataSource processToCheckoutDataSource = ProcessToCheckoutDataSourceImpl();
  int orderId = -1;

  Future<void> createOrder({required BuildContext context, required String paymentMethod}) async {
    if (isClosed) return;
    emit(CreateOrderLoading());
    animationDialogLoading(context);
    await processToCheckoutDataSource.processToCheckout(addressId: addressId, paymentMethod: paymentMethod).then(
      (value) async {
        closeDialog(context);
        value.fold((l) {
          if (isClosed) return;
          emit(CreateOrderError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          orderId = r;
          logger.w('orderId ==>$orderId');
          afterSuccessCreateOrder(
            context: context,
            selectedPaymentMethod: paymentMethod,
          );
          if (isClosed) return;
          emit(CreateOrderSuccess());
        });
      },
    );
  }

  Future<void> afterSuccessCreateOrder({required BuildContext context, required String selectedPaymentMethod}) async {
    if (selectedPaymentMethod == EnumPaymentMethod.stc.name && orderId != -1) {
      await startStcPayment(context: context);
    } else if (selectedPaymentMethod == EnumPaymentMethod.credit.name && orderId != -1) {
      await startCreditPayment(context: context, amount: '${ConstantsModels.checkoutDetailsModel?.subTotalPrice}', orderId: '$orderId');
    } else if (selectedPaymentMethod == 'invoice' && orderId != -1) {
      await startCreditPayment(context: context, amount: '${ConstantsModels.checkoutDetailsModel?.subTotalPrice}', orderId: '$orderId');
    } else {
      finish(context, duration: false);
    }
  }

  String selectedPaymentMethod = 'Cash';
  List<String> paymentMethod = [
    'Cash',
  ];

  // get Payment Method
  Future<void> getAllPaymentMethod() async {
    emit(GetAllPaymentsLoading());
    ConstantsModels.paymentMethodModel = null;
    await paymentDataSource.getPaymentMethod().then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          emit(GetAllPaymentsError(e: l.errMessage));
        }, (r) async {
          ConstantsModels.paymentMethodModel = null;
          ConstantsModels.paymentMethodModel = r;
          r.data?.forEach((element) {
            element.allowedPaymentMethods?.forEach((element) {
              paymentMethod.add(element);
            });
          });
          emit(GetAllPaymentsSuccess());
        });
      },
    );
  }

  void changePaymentMethod(String value) {
    selectedPaymentMethod = value;
    emit(PaymentInitial());
  }

  // ====== stc payment ======
  Future<void> startStcPayment({required BuildContext context}) async {
    await showSaudiPhoneBottomSheet(
      context: context,
      onSubmit: (phoneNumber) async {
        logger.d('phone number is $phoneNumber');
        await createSTCFirst(context: context, orderId: '$orderId', mobile: phoneNumber);
      },
      initialPhoneNumber: myPhoneForStc(ConstantsModels.registerModel?.data?.phone ?? ''),
    );
  }

  String? myPhoneForStc(String phone) {
    String? newPhone;
    if (phone.isNotEmpty && phone.contains('+966')) {
      newPhone = phone.replaceAll('+966', '0');
    }
    return newPhone;
  }

  Future<void> createSTCFirst({required BuildContext context, required String orderId, required String mobile}) async {
    emit(CreateSTCFirstLoading());
    animationDialogLoading(context);
    await paymentDataSource
        .paymentStcFirstMethod(
      params: PaymentStcFirstParams(
        amount: '${ConstantsModels.checkoutDetailsModel?.subTotalPrice}',
        orderId: orderId,
        mobile: mobile,
      ),
    )
        .then(
      (value) async {
        closeDialog(context);
        value.fold((l) {
          emit(CreateSTCFirstError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          await showOtpVerificationBottomSheet(
            context: context,
            onSubmit: (otpCode) async {
              // Handle the 6-digit OTP code
              await createSTCSecond(context: context, transactionUrl: r.transactionUrl ?? '', otp: otpCode);
            },
            onResendCode: () {
              // Handle resend code logic
            },
            phoneNumber: '+966 $mobile',
            // Display phone number
            initialOtpValue: '', // Optional pre-filled value
          );
          emit(CreateSTCFirstSuccess());
        });
      },
    );
  }

  Future<void> createSTCSecond({required BuildContext context, required String transactionUrl, required String otp}) async {
    emit(CreateSTCSecondLoading());
    animationDialogLoading(context);
    await paymentDataSource
        .paymentStcSecondMethod(
      transactionUrl: transactionUrl,
      otp: otp,
    )
        .then(
      (value) async {
        closeDialog(context);
        value.fold((l) {
          emit(CreateSTCSecondError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          logger.w(r);
          if (r == 'paid') {
            Utils.showToast(title: 'Payment successful'.tr(), state: UtilState.success);
          } else {
            Utils.showToast(title: 'Payment failed'.tr(), state: UtilState.error);
          }
          finish(context);
          emit(CreateSTCSecondSuccess());
        });
      },
    );
  }

  // ====== credit payment ======
  Future<void> startCreditPayment({required BuildContext context, required String amount, required String orderId}) async {
    emit(CreateCreditLoading());
    animationDialogLoading(context);
    await paymentDataSource
        .paymentCreditMethod(
      params: PaymentCreditParams(
        amount: '${ConstantsModels.checkoutDetailsModel?.subTotalPrice}',
        orderId: orderId,
      ),
    )
        .then(
      (value) async {
        closeDialog(context);
        value.fold((l) {
          emit(CreateCreditError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          logger.w(r);
          context.navigateToPage(
            MyInAppWebView(
              authorizationUrl: r.url ?? 'https://checkout.moyasar.com/invoices/80283fa9-167f-4121-b43e-dec01eccd656?lang=en',
              scaffoldContext: context,
              onPageStarted: (String url) async {
                log('url payment $url');
                if (url.contains('paid')) {
                  Utils.showToast(title: 'Payment successful'.tr(), state: UtilState.success);
                  finish(context);
                } else if (url.contains('fail')) {
                  Utils.showToast(title: 'Payment failed'.tr(), state: UtilState.error);
                  finish(context);
                }
              },
              onPageFinished: (String url) async {
                log('url payment $url');
                if (url.contains('paid')) {
                  Utils.showToast(title: 'Payment successful'.tr(), state: UtilState.success);
                  finish(context);
                } else if (url.contains('fail')) {
                  Utils.showToast(title: 'Payment failed'.tr(), state: UtilState.error);
                  finish(context);
                }
              },
              onPopInvokedWithResult: (success, result) async {
                finish(context);
              },
            ),
          );
          emit(CreateCreditSuccess());
        });
      },
    );
  }

  void finish(BuildContext context, {bool duration = true}) {
    Future.delayed(Duration(seconds: duration ? 2 : 0), () {
      context.navigateToPageWithReplacement(
        const NavigationViewWithThemes(
          initialIndex: 1,
        ),
      );
      context.navigateToPage(const MyOrderView());
    });
  }
}
