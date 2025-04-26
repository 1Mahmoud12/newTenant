import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:device_info_plus/device_info_plus.dart';
part 'main_cubit_state.dart';

class MainCubitCubit extends Cubit<MainCubitState> {
  MainCubitCubit() : super(MainCubitInitial());
 static MainCubitCubit of(BuildContext context) {
    return BlocProvider.of<MainCubitCubit>(context);
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
