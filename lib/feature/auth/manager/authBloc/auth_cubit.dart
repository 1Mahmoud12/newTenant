import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/bottomSheet/failure_bottom_sheet_with_reason.dart';
import 'package:dobzz_seller/core/utils/bottomSheet/select_county_code_dialog.dart';
import 'package:dobzz_seller/core/utils/bottomSheet/success_bottom_sheet.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/custom_show_toast.dart';
import 'package:dobzz_seller/core/utils/errorLoadingWidgets/dialog_loading_animation.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/auth/data/dataSource/aut_data_source.dart';
import 'package:dobzz_seller/feature/auth/data/models/login_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/reset_password_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/sign_up_params.dart';
import 'package:dobzz_seller/feature/auth/data/models/verify_code_model.dart';
import 'package:dobzz_seller/feature/auth/forgetPassword/view/presentation/reset_password_view.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_state.dart';
import 'package:dobzz_seller/feature/auth/verifyCode/view/presentation/verify_code_view.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit of(BuildContext context) => BlocProvider.of<AuthCubit>(context);

  final AuthDataSource authDataSource = AuthDataSourceImpl();

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
          setCountryCodeId(r.data?.first.id ?? 1);
          emit(AuthGetCountryCodeSuccessState());
        });
      },
    );
  }

  void forgetPassword({required BuildContext context}) async {
    emit(AuthGetCountryCodeLoadingState());
    animationDialogLoading(context);
    authDataSource.forgetPassword(context, phoneController.text, countryCodeId).then(
      (value) async {
        closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          failureModalBottomSheetWithReason(context, reasons: [l.errMessage], onPress: () {});
          emit(AuthGetCountryCodeErrorState(l.errMessage));
        }, (r) async {
          context.navigateToPage(
            VerifyCodeView(
              // phoneNumber: phoneController.text,
              // countryCodeId: countryCodeId,
              // verifyButton: (context) {
              //   context.navigateToPage(const ResetPasswordView());
              // },
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
    customShowToast(context, 'we_send_again_code_for_you'.tr());
    authDataSource.resendCode(context, phoneController.text, countryCodeId).then(
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
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  int gender = 1;
  int countryCodeId = 1;
  Country country = countries.first;

  void setGender(int value) {
    gender = value;
    emit(AuthSetGenderState());
  }

  void setCountryCodeId(int value) {
    countryCodeId = value;
    country = countries.firstWhere((element) => element.id == value);
    emit(AuthSetCountryCodeState());
  }

  void signUp(BuildContext context) async {
    emit(AuthSignUpLoadingState());
    animationDialogLoading(context);
    authDataSource
        .postSignUp(
      context,
      SignUpParams(
        name: nameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
        password: passwordController.text,
        birthday: nationalIdController.text,
        gender: gender,
        userName: phoneController.text,
        countryCodeId: countryCodeId,
        fcmToken: Constants.fcmToken,
        deviceTypeId: Constants.deviceId,
      ),
    )
        .then(
      (value) async {
        closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          failureModalBottomSheetWithReason(context, reasons: [l.errMessage], onPress: () {});
          emit(AuthSignUpErrorState(l.errMessage));
        }, (r) async {
          customShowToast(context, 'created_user_successfully'.tr());
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
    emit(AuthVerifyLoadingState());
    animationDialogLoading(context);
    authDataSource
        .verifyCode(
      context,
      VerifyCodeModel(
        otp: codeController.text,
        phone: phoneController.text,
        countryCodeId: countryCodeId,
      ),
    )
        .then(
      (value) async {
        closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          failureModalBottomSheetWithReason(context, reasons: [l.errMessage], onPress: () {});
          emit(AuthVerifyErrorState(l.errMessage));
        }, (r) async {
          ConstantsModels.registerModel = r;
          userCacheValue = r;
          Constants.token = r.data?.token ?? '';
          userCache?.put(userCacheKey, jsonEncode(r.toJson()));
          successModalBottomSheet(
            context,
            title: 'user_confirmed_successfully'.tr(),
            subTitle: 'you_can_now_entertainment_with_the_app',
            nameButton: 'go_home',
            onPress: () {
              context.navigateToPageWithReplacement(const NavigationView());
              phoneController.clear();
              passwordController.clear();
              confirmPasswordController.clear();
            },
          );
          emit(AuthVerifySuccessState());
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
        phoneNumber: phoneController.text,
        password: passwordController.text,
        countryCodeId: countryCodeId,
        fcmToken: Constants.fcmToken,
        deviceTypeId: Constants.deviceId,
      ),
    )
        .then(
      (value) async {
        closeDialog(context);
        // bool result = await InternetConnectionChecker().hasConnection;
        value.fold((l) {
          failureModalBottomSheetWithReason(context, reasons: [l.errMessage], onPress: () {});
          errorMessage = l.errMessage;
          emit(AuthLoginErrorState(l.errMessage));
        }, (r) async {
          ConstantsModels.registerModel = r;
          userCacheValue = r;
          Constants.token = r.data?.token ?? '';
          userCache?.put(userCacheKey, jsonEncode(r.toJson()));
          context.navigateToPageWithReplacement(const NavigationView());
          phoneController.clear();
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
        userId: idUserValue,
        code: int.parse(codeController.text),
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
          phoneController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          emit(AuthResetPasswordSuccessState());
        });
      },
    );
  }
}
