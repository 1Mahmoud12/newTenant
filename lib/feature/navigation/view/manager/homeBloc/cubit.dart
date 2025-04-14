import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/feature/navigation/view/manager/homeBloc/state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit of(BuildContext context) => BlocProvider.of<HomeCubit>(context);

  void changeLanguage(Locale locale, BuildContext context) {
    context.setLocale(locale);
    arabicLanguage = locale.languageCode == 'ar';
    log('cubit $arabicLanguage');
    Constants.fontFamily = arabicLanguage ? 'Tajawal' : 'Inter';
    userCache?.put(languageAppKey, arabicLanguage);
    emit(ChangeInitialState());
  }

  void changeTheme(BuildContext context) {
    darkModeValue = !darkModeValue;

    userCache?.put(darkModeKey, darkModeValue);

    emit(ChangeThemeState());
  }

  // final HomeDataSource homeDataSource = HomeDataSourceImpl();
  //
  // Future<void> getAllBranches() async {
  //   emit(HomeGetAllBranchesLoadingState());
  //
  //   homeDataSource.getBranches().then(
  //     (value) async {
  //       // bool result = await InternetConnectionChecker().hasConnection;
  //       value.fold((l) {
  //         Utils.showToast(title: l.errMessage, state: UtilState.error);
  //         emit(HomeGetAllBranchesErrorState(l.errMessage));
  //       }, (r) async {
  //         ConstantsModels.branchesModel = r;
  //
  //         emit(HomeGetAllBranchesSuccessState());
  //       });
  //     },
  //   );
  // }
  //
  void changeState() {
    emit(HomeChangeState());
  }
  //
  // final NotificationDataSource notificationDataSource = NotificationDataSourceImpl();
  // int notificationCount = 0;
  //
  // void getNotificationCount() async {
  //   emit(GetHomeNotificationLoadingState());
  //   // animationDialogLoading(context);
  //   notificationDataSource.notificationCount().then(
  //     (value) async {
  //       //  closeDialog(context);
  //       // bool result = await InternetConnectionChecker().hasConnection;
  //       value.fold((l) {
  //         Utils.showToast(title: l.errMessage, state: UtilState.error);
  //         emit(GetHomeNotificationErrorState(l.errMessage));
  //       }, (r) {
  //         notificationCount = r.toInt();
  //
  //         emit(GetHomeNotificationSuccessState());
  //       });
  //     },
  //   );
  // }
  //
  // void clearAllNotification() {
  //   notificationCount = 0;
  //   emit(ReadHomeAllNotificationState());
  // }

  // void readOneNotification() {
  //   notificationCount--;
  //   emit(ReadHomeOneNotificationState());
  // }
  //
  // void getAllCategories() async {
  //   emit(GetCategoriesLoadingState());
  //   // animationDialogLoading(context);
  //   homeDataSource.getAllCategories().then(
  //     (value) async {
  //       //  closeDialog(context);
  //       // bool result = await InternetConnectionChecker().hasConnection;
  //       value.fold((l) {
  //         Utils.showToast(title: l.errMessage, state: UtilState.error);
  //         emit(GetCategoriesErrorState(l.errMessage));
  //       }, (r) async {
  //         categories.clear();
  //         ConstantsModels.categoriesModel = r;
  //         for (int i = 0; i < r.data!.length; i++) {
  //           categories.add(
  //             CategoriesModel(
  //               nameImage: r.data![i].imageUrl ?? AppIcons.washingIc,
  //               nameServices:
  //                   (navigatorKey.currentState!.context.locale.languageCode == 'ar' ? r.data![i].categoryNameAr : r.data![i].categoryNameEn) ?? '',
  //               idServices: r.data![i].categoryId ?? -1,
  //             ),
  //           );
  //         }
  //         // for (int i = 0; i < r.dataSource!.femaleCategories!.length; i++) {
  //         //   services.add(ServicesModel(
  //         //       nameImage: AppIcons.washingIc,
  //         //       nameServices: (arabicLanguage ? r.dataSource!.femaleCategories![i].categoryNameAr : r.dataSource!.femaleCategories![i].categoryNameEn) ?? ''));
  //         // }
  //         // services=
  //
  //         // userCache?.put(categoriesModelKey, jsonEncode(r.toJson()));
  //         //categoriesModelCache = r;
  //         emit(GetCategoriesSuccessState());
  //       });
  //     },
  //   );
  // }
}
