import 'package:bloc/bloc.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/dialog_loading_animation.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/my_order_view.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/dataSource/process_to_checkout_data_source.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/data/models/payment_stc_first_params.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/presentation/view/widgets/add_phone_payment.dart';
import 'package:dobzz_seller/feature/cart/view/checkout/presentation/view/widgets/show_otp.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';
import 'package:dobzz_seller/main.dart';
import 'package:flutter/material.dart';

part 'process_to_checkout_state.dart';

class ProcessToCheckoutCubit extends Cubit<ProcessToCheckoutState> {
  ProcessToCheckoutCubit() : super(ProcessToCheckoutInitial());
  String addressId = Constants.defaultAddress.addressId.toString();
  ProcessToCheckoutDataSource processToCheckoutDataSource = ProcessToCheckoutDataSourceImpl();
  int orderId = -1;

  Future<void> processToCheckout({required BuildContext context}) async {
    if (isClosed) return;
    emit(ProcessToCheckoutLoading());

    await processToCheckoutDataSource.processToCheckout(addressId: addressId).then(
      (value) async {
        value.fold((l) {
          if (isClosed) return;
          emit(ProcessToCheckoutError(e: l.errMessage));
          Utils.showToast(title: l.errMessage, state: UtilState.error);
        }, (r) async {
          orderId = r;
          if (selectedPaymentMethod == 'stc' && orderId != -1) {
            await startStcPayment(context: context);
          } else {
            context.navigateToPageWithReplacement(
              const NavigationViewWithThemes(
                initialIndex: 1,
              ),
            );
            context.navigateToPage(const MyOrderView());
          }
          if (isClosed) return;
          emit(ProcessToCheckoutSuccess());
        });
      },
    );
  }

  String selectedPaymentMethod = 'Cash';
  List<String> paymentMethod = [
    'Cash',
  ];

  // get Payment Method
  Future<void> getAllPaymentMethod() async {
    emit(GetAllPaymentsLoading());
    ConstantsModels.paymentMethodModel = null;
    await processToCheckoutDataSource.getPaymentMethod().then(
      (value) async {
        value.fold((l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          emit(GetAllPaymentsError(e: l.errMessage));
        }, (r) async {
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
    emit(ProcessToCheckoutInitial());
  }

  // ====== stc payment ======
  Future<void> startStcPayment({required BuildContext context}) async {
    await showSaudiPhoneBottomSheet(
      context: context,
      onSubmit: (phoneNumber) async {
        logger.d('phone number is $phoneNumber');
        await createSTCFirst(context: context, orderId: '$orderId', mobile: phoneNumber);
      },
      // initialPhoneNumber: ConstantsModels.registerModel?.data?.phone,
    );
  }

  Future<void> createSTCFirst({required BuildContext context, required String orderId, required String mobile}) async {
    emit(CreateSTCFirstLoading());
    animationDialogLoading(context);
    await processToCheckoutDataSource
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
              print('Received OTP: $otpCode');
              await createSTCSecond(context: context, transactionUrl: r.transactionUrl ?? '', otp: otpCode);
            },
            onResendCode: () {
              // Handle resend code logic
              print('Resending OTP code');
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
    await processToCheckoutDataSource
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
            Utils.showToast(title: 'تم الدفع بنجاح', state: UtilState.success);
          } else {
            Utils.showToast(title: 'لم يتم الدفع بنجاح', state: UtilState.error);
          }
          context.navigateToPageWithReplacement(
            const NavigationViewWithThemes(
              initialIndex: 1,
            ),
          );
          context.navigateToPage(const MyOrderView());
          emit(CreateSTCSecondSuccess());
        });
      },
    );
  }
}
