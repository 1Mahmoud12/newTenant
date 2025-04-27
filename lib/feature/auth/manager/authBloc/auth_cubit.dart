import 'dart:convert';
import 'dart:developer';

import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:dobzz_seller/feature/auth/forgetPassword/view/presentation/reset_password_view.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/bottomSheet/failure_bottom_sheet_with_reason.dart';
import 'package:dobzz_seller/core/utils/bottomSheet/select_county_code_dialog.dart';
import 'package:dobzz_seller/core/utils/bottomSheet/success_bottom_sheet.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/dialog_loading_animation.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/data/dataSource/aut_data_source.dart';
import 'package:dobzz_seller/feature/auth/data/models/login_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/reset_password_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/sign_up_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/verify_code_model.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_state.dart';
import 'package:dobzz_seller/feature/auth/verifyCode/view/presentation/verify_code_view.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit of(BuildContext context) => BlocProvider.of<AuthCubit>(context);

  final AuthDataSource authDataSource = AuthDataSourceImpl();
  int termAndCondition = 0;
  void changeStat() {
    emit(AuthInitial());
  }

  void getCountryCode() async {
    emit(AuthGetCountryCodeLoadingState());
    // animationDialogLoading(context);
    authDataSource.getCountryCode().then(
      (value) async {
        //  closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          //   failureModalBottomSheetWithReason(context, reasons: [l.errMessage], onPress: (){});
          emit(AuthGetCountryCodeErrorState(l.errMessage));
        }, (r) async {
          ConstantsModels.countryCodeModel = r;
          // setCountryCodeId(r.data?.first.id ?? 1);
          emit(AuthGetCountryCodeSuccessState());
        });
      },
    );
  }

  void forgetPassword({required BuildContext context}) async {
    emit(AuthGetCountryCodeLoadingState());
    animationDialogLoading(context);
    authDataSource.forgetPassword(context, phone: countryCode + phoneController.text).then(
      (value) async {
        closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          failureModalBottomSheetWithReason(context, reasons: [l.errMessage], onPress: () {});
          emit(AuthGetCountryCodeErrorState(l.errMessage));
        }, (r) async {
          //   await authDataSource.resendCode(context, customerId: userCacheValue?.data?.id.toString() ?? '-1');

          context.navigateToPage(
            VerifyCodeView(
              // phoneNumber: phoneController.text,
              // countryCodeId: countryCodeId,
              verifyButton: (context) async {
                context.navigateToPage(const ResetPasswordView());
              },
            ),
          );
          emit(AuthGetCountryCodeSuccessState());
        });
      },
    );
  }

  void resendCode({required BuildContext context}) async {
    emit(AuthResendCodeLoadingState());
    animationDialogLoading(context);
    //   customShowToast(context, 'we_send_again_code_for_you'.tr());
    authDataSource.resendCode(context, customerId: ConstantsModels.requiredValidationModel?.data?.id.toString() ?? '-1').then(
      (value) async {
        closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          failureModalBottomSheetWithReason(context, reasons: [l.errMessage], onPress: () {});
          emit(AuthResendCodeErrorState(l.errMessage));
        }, (r) async {
          emit(AuthResendCodeSuccessState());
        });
      },
    );
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  int gender = 1;
  String countryCode = '+966';
  Country country = countries.first;

  void setGender(int value) {
    gender = value;
    emit(AuthSetGenderState());
  }

  // void setCountryCodeId(int value) {
  //   countryCodeId = value;
  //   country = countries.firstWhere((element) => element.id == value);
  //   emit(AuthSetCountryCodeState());
  // }

  void signUp(BuildContext context) async {
    emit(AuthSignUpLoadingState());
    animationDialogLoading(context);
    authDataSource
        .postSignUp(
      context,
      SignUpParams(
        name: nameController.text,
        phone: countryCode + phoneController.text,
        password: passwordController.text,
        termAndCondition: termAndCondition,
      ),
    )
        .then(
      (value) async {
        value.fold((l) {
          closeDialog(context);
          // Extract error reasons if available
          List<String> errorReasons = [];
          if (l is ServerFailure && l.apiError != null) {
            errorReasons = l.apiError!.getErrorsList();
          } else {
            errorReasons = [l.errMessage];
          }
          failureModalBottomSheetWithReason(context, reasons: errorReasons, onPress: () {});
          // customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
          emit(AuthSignUpErrorState(l.errMessage));
        }, (r) async {
          closeDialog(context);
          // closeDialog(context);
          // customShowToast(context, 'created_user_successfully'.tr());
          emit(AuthSignUpSuccessState());
        });
      },
    );
  }

  TextEditingController codeController = TextEditingController();

  void setCodeController(String value) {
    codeController.text = value;
    emit(AuthSetCodeState());
  }

  void verifyCode(BuildContext context) async {
    final otpValue = otpController.text;
    emit(AuthVerifyLoadingState());
    animationDialogLoading(context);
    authDataSource
        .verifyCode(
      context,
      VerifyCodeModel(
        otp: otpValue,
        customerId: ConstantsModels.requiredValidationModel?.data?.id.toString() ?? '-1',
      ),
    )
        .then(
      (value) async {
        // closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          closeDialog(context);
          failureModalBottomSheetWithReason(context, reasons: [l.errMessage], onPress: () {});
          emit(AuthVerifyErrorState(l.errMessage));
        }, (r) async {
          closeDialog(context);
          ConstantsModels.registerModel = r;
          userCacheValue = r;
          Constants.token = r.data?.token ?? '';
          userCache?.put(userCacheKey, jsonEncode(r.toJson()));
          context.navigateToPage(const LoginScreen());
          //  emit(AuthVerifySuccessState());
        });
      },
    );
  }

  String? errorMessage;

  void login(BuildContext context) async {
    emit(AuthLoginLoadingState());
    animationDialogLoading(context);
    authDataSource
        .postLogin(
      context,
      LoginParams(
        phone: countryCode + phoneController.text,
        password: passwordController.text,
      ),
    )
        .then(
      (value) async {
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          closeDialog(context);
          // Extract error reasons if available
          List<String> errorReasons = [];
          if (l is ServerFailure && l.apiError != null) {
            errorReasons = l.apiError!.getErrorsList();
          } else {
            errorReasons = [l.errMessage];
          }
          if (l.errMessage == 'You have To Verify Your Phone') {
            authDataSource.resendCode(context, customerId: ConstantsModels.requiredValidationModel?.data?.id.toString() ?? '-1');
            failureModalBottomSheetWithReason(
              buttonName: 'verify_code'.tr(),
              context,
              reasons: errorReasons,
              onPress: () {
                context.navigateToPage(
                  const VerifyCodeView(
                      // phoneNumber: AuthCubit.of(context).phoneController.text,
                      // countryCodeId: AuthCubit.of(context).countryCodeId,
                      // verifyButton: (context) {
                      //   AuthCubit.of(context).verifyCode(context);
                      // },
                      ),
                );
              },
            );
          } else {
            failureModalBottomSheetWithReason(context, reasons: errorReasons, onPress: () {});
          }

          emit(AuthLoginErrorState(l.errMessage));
        }, (r) async {
          ConstantsModels.registerModel = r;
          userCacheValue = r;
          log('userCacheValue.data ==>${userCacheValue?.data}');
          Constants.token = r.data?.token ?? '';
          await userCache?.put(userCacheKey, jsonEncode(r.toJson()));
          context.navigateToPageWithClearStack(const NavigationViewWithThemes());
          lastNameController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          emit(AuthLoginSuccessState());
        });
      },
    );
  }

  void resetPassword(BuildContext context) async {
    emit(AuthResetPasswordLoadingState());
    animationDialogLoading(context);
    authDataSource
        .resetPasswordPassword(
      context,
      ResetPasswordParams(
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      ),
    )
        .then(
      (value) async {
        closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          failureModalBottomSheetWithReason(context, reasons: [l.errMessage], onPress: () {});
          emit(AuthResetPasswordErrorState(l.errMessage));
        }, (r) async {
          lastNameController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          emit(AuthResetPasswordSuccessState());
        });
      },
    );
  }

  // void disposeControllers() {
  //   // Dispose all text controllers
  //   nameController.dispose();
  //   lastNameController.dispose();
  //   phoneController.dispose();
  //   passwordController.dispose();
  //   confirmPasswordController.dispose();
  //   nationalIdController.dispose();
  //   otpController.dispose();
  //   codeController.dispose();
  // }

  // @override
  // Future<void> close() {
  //   // Dispose controllers before closing the cubit
  //   disposeControllers();
  //   return super.close();
  // }
}
