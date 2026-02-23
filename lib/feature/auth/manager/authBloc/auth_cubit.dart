import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rova_star/core/network/errors/failures.dart';
import 'package:rova_star/core/network/local/cache.dart';
import 'package:rova_star/core/utils/bottomSheet/failure_bottom_sheet_with_reason.dart';
import 'package:rova_star/core/utils/bottomSheet/select_county_code_dialog.dart';
import 'package:rova_star/core/utils/constants.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/core/utils/errorLoadingWidgets/dialog_loading_animation.dart';
import 'package:rova_star/core/utils/navigate.dart';
import 'package:rova_star/feature/auth/data/dataSource/aut_data_source.dart';
import 'package:rova_star/feature/auth/data/models/login_params.dart';
import 'package:rova_star/feature/auth/data/models/sign_up_params.dart';
import 'package:rova_star/feature/auth/data/models/verify_code_model.dart';
import 'package:rova_star/feature/auth/manager/authBloc/auth_state.dart';
import 'package:rova_star/feature/auth/verifyCode/view/presentation/verify_code_view.dart';
import 'package:rova_star/feature/navigation/view/presentation/navigation_view.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit of(BuildContext context) =>
      BlocProvider.of<AuthCubit>(context);

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

  void forgetPassword({
    required BuildContext context,
    bool navigateToVerifyCodeView = true,
  }) async {
    emit(AuthGetCountryCodeLoadingState());
    animationDialogLoading(context);
    authDataSource
        .forgetPassword(context, phone: countryCode + phoneController.text)
        .then(
      (value) async {
        closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          failureModalBottomSheetWithReason(
            context,
            reasons: [l.errMessage],
            onPress: () {},
          );
          emit(AuthGetCountryCodeErrorState(l.errMessage));
        }, (r) async {
          if (navigateToVerifyCodeView) {
            context.navigateToPage(
              const VerifyCodeView(
                isForgetPassword: true,
                isLogin: false,
              ),
            );
          }
          emit(AuthGetCountryCodeSuccessState());
        });
      },
    );
  }

  void resendCode({
    required BuildContext context,
    required bool isLogin,
  }) async {
    emit(AuthResendCodeLoadingState());
    animationDialogLoading(context);
    //   customShowToast(context, 'we_send_again_code_for_you'.tr());
    authDataSource
        .resendCode(
      context,
      phone: countryCode + phoneController.text,
      customerId: Constants.customerId,
      isLogin: isLogin,
    )
        .then(
      (value) async {
        closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          failureModalBottomSheetWithReason(
            context,
            reasons: [l.errMessage],
            onPress: () {},
          );
          emit(AuthResendCodeErrorState(l.errMessage));
        }, (r) async {
          emit(AuthResendCodeSuccessState());
          log('token===========> $r');
        });
      },
    );
  }

// login controllers
  TextEditingController loginPhoneController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
// reset password
  // TextEditingController resetPasswordController = TextEditingController();
  //TextEditingController resetConfirmationPasswordController = TextEditingController();

//
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  //TextEditingController passwordController = TextEditingController();
  //TextEditingController confirmPasswordController = TextEditingController();
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
        //  password: passwordController.text,
        termAndCondition: termAndCondition,
      ),
    )
        .then(
      (value) async {
        closeDialog(context);
        value.fold((l) {
          // Extract error reasons if available
          List<String> errorReasons = [];
          if (l is ServerFailure && l.apiError != null) {
            errorReasons = l.apiError!.getErrorsList();
          } else {
            errorReasons = [l.errMessage];
          }
          failureModalBottomSheetWithReason(
            context,
            reasons: errorReasons,
            onPress: () {},
          );
          // customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
          emit(AuthSignUpErrorState(l.errMessage));
        }, (r) async {
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

  void verifyCode(
    BuildContext context, {
    bool isForgetPassword = false,
    bool isLogin = false,
  }) async {
    final otpValue = otpController.text;
    emit(AuthVerifyLoadingState());
    animationDialogLoading(context);
    authDataSource
        .verifyCode(
      context,
      VerifyCodeModel(
        otp: otpValue,
        phone: isForgetPassword ? countryCode + phoneController.text : null,
        customerId: Constants.customerId,
      ),
      isForgetPassword: isForgetPassword,
    )
        .then(
      (value) async {
        closeDialog(context);

        // closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          otpController.clear();
          failureModalBottomSheetWithReason(
            context,
            reasons: [l.errMessage],
            onPress: () {},
          );
          emit(AuthVerifyErrorState(l.errMessage));
        }, (r) async {
          if (isForgetPassword) {
            Constants.token = r.data?.token ?? '';
            // context.navigateToPage(
            //   const ResetPasswordView(
            //     openLoginScreen: true,
            //   ),
            // );
          } else {
            ConstantsModels.registerModel = r;
            loginCacheValue = r;
            Constants.token = r.data?.token ?? '';
            loginCache?.put(loginCacheKey, jsonEncode(r.toJson()));
            // // Save biometric login data after successful verification
            // if (isLogin) {
            //   final biometricService = BiometricService();
            //   final phone = countryCode + loginPhoneController.text;
            //
            //   // Check if device supports biometrics
            //   final isSupported = await biometricService.isDeviceSupported();
            //   final canCheck = await biometricService.canCheckBiometrics();
            //
            //   if (isSupported && canCheck) {
            //     // Enable biometric login with saved credentials
            //     await biometricService.enableBiometricLogin(
            //       r,
            //       phone: phone,
            //     );
            //     log('Biometric login data saved successfully');
            //   }
            // }

            context.navigateToPage(const NavigationViewWithThemes());
            phoneController.clear();
            otpController.clear();
            loginPhoneController.clear();
            loginPasswordController.clear();
            // passwordController.clear();
          }

          emit(AuthVerifySuccessState());
        });
      },
    );
  }

  String? errorMessage;

  Future<bool> login(BuildContext context) async {
    emit(AuthLoginLoadingState());
    animationDialogLoading(context);
    final result = await authDataSource.postLogin(
      context,
      LoginParams(
        phone: countryCode + loginPhoneController.text,
        password: loginPasswordController.text,

      ),
    );
    return result.fold((l) {
      closeDialog(context);
      // Extract error reasons if available
      List<String> errorReasons = [];
      if (l is ServerFailure && l.apiError != null) {
        errorReasons = l.apiError!.getErrorsList();
      } else {
        errorReasons = [l.errMessage];
      }
      if (l.errMessage == 'You have To Verify Your Phone') {
        //authDataSource.resendCode(context, phone: countryCode + loginPhoneController.text);
        context.navigateToPage(
          const VerifyCodeView(
            isForgetPassword: false,
            isLogin: true,
          ),
        );
      } else {
        failureModalBottomSheetWithReason(
          context,
          reasons: errorReasons,
          onPress: () {},
        );
      }

      emit(AuthLoginErrorState(l.errMessage));
      return false;
    }, (r) async {
      ConstantsModels.registerModel = r;
      loginCacheValue = r;
      Constants.customerId = r.data!.id!.toString();
      log('userCacheValue.data ==>${loginCacheValue?.data?.token}');
      Constants.token = r.data?.token ?? '';
      // Mirror userCache payload into login cache for system biometric
      await loginCache?.put(loginCacheKey, jsonEncode(r.toJson()));
      await loginCache?.put(biometricAuthKey, r.data?.token ?? '');
      await loginCache?.put(biometricUserCacheKey, jsonEncode(r.toJson()));

      context.navigateToPage(
        const VerifyCodeView(isForgetPassword: false, isLogin: true),
      );
      loginPhoneController.clear();
      loginPasswordController.clear();
      emit(AuthLoginSuccessState());
      return true;
    });
  }

// void resetPassword(BuildContext context) async {
//   emit(AuthResetPasswordLoadingState());
//   animationDialogLoading(context);
//   authDataSource
//       .resetPasswordPassword(
//     context,
//     ResetPasswordParams(
//       password: resetPasswordController.text,
//       confirmPassword: resetConfirmationPasswordController.text,
//     ),
//   )
//       .then(
//     (value) async {
//       closeDialog(context);
//       // bool result = await InternetConnectionChecker().hasConnection;
//       value.fold((l) {
//         failureModalBottomSheetWithReason(context, reasons: [l.errMessage], onPress: () {});
//         emit(AuthResetPasswordErrorState(l.errMessage));
//       }, (r) async {
//         userCacheValue = null;
//         await userCache?.clear();
//         lastNameController.clear();
//         passwordController.clear();
//         confirmPasswordController.clear();
//         resetPasswordController.clear();
//         resetConfirmationPasswordController.clear();
//         otpController.clear();
//         emit(AuthResetPasswordSuccessState());
//       });
//     },
//   );
// }
}
