import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:device_info_plus/device_info_plus.dart';
part 'main_cubit_state.dart';

class MainCubitCubit extends Cubit<MainCubitState> {
  MainCubitCubit() : super(MainCubitInitial());
  static MainCubitCubit of(BuildContext context) => BlocProvider.of<MainCubitCubit>(context);

  void changeLanguage(Locale locale, BuildContext context) {
    context.setLocale(locale);

    emit(ChangeInitialState());
  }

  Future<String?> getDeviceIdentifier() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }
}
