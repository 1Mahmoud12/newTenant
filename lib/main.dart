import 'dart:convert';
import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:rova_star/core/utils/bloc_observe.dart';
import 'package:rova_star/core/utils/constants.dart';
import 'package:rova_star/feature/auth/data/models/register_model.dart';
import 'package:rova_star/feature/navigation/view/presentation/navigation_view.dart';
import 'package:rova_star/feature/splash/view/presentation/splash_screen.dart';

import 'core/network/dio_helper.dart';
import 'core/network/local/cache.dart';
import 'core/network/local/hive_data_base.dart';
import 'core/utils/notification/notification.dart';
import 'firebase_options.dart';
import 'my_app.dart';

//notification icon make it base color , the padding between product cards ,

Widget appStartScreen = const SplashScreen();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized(); // Add this line
  await ScreenUtil.ensureScreenSize();

  EasyLocalization.logger.enableBuildModes = [];
  // Hive
  await Hive.initFlutter();
  //await selectTokens();
  // Dio

  await DioHelper.init();

  userCache = await openHiveBox(userCacheBoxKey);
  loginCache = await openHiveBox(loginCacheBoxKey);
  // get device id
  // final MainCubitCubit mainCubit = MainCubitCubit();
  // Constants.deviceId = await mainCubit.getDeviceIdentifier() ?? '';
  // log('deviceId ==>${Constants.deviceId}');

  onBoardingValue = userCache?.get(onBoardingKey, defaultValue: true);
  darkModeValue = userCache?.get(darkModeKey, defaultValue: false);
  locationCacheValue = userCache?.get(locationCacheKey);
  // Load login cache first; if legacy userCache exists, migrate it to loginCache
  loginCacheValue = RegisterModel.fromJson(jsonDecode(await loginCache?.get(loginCacheKey, defaultValue: '{}')));
  if ((loginCacheValue?.data?.token == null || (loginCacheValue?.data?.token?.isEmpty ?? true))) {
    try {
      final raw = await loginCache?.get(loginCacheKey, defaultValue: '{}');
      if (raw != null && (raw as String).isNotEmpty && raw != '{}') {
        final migrated = RegisterModel.fromJson(jsonDecode(raw));
        loginCacheValue = migrated;
        await loginCache?.put(loginCacheKey, jsonEncode(migrated.toJson()));
        await loginCache?.put(biometricAuthKey, migrated.data?.token ?? '');
        await loginCache?.put(biometricUserCacheKey, jsonEncode(migrated.toJson()));
      }
    } catch (e) {
      log('migrate userCache to loginCache error: $e');
    }
  }
  log('userCacheValue ==>$loginCacheValue');
  log('userCacheValue.data ==>${loginCacheValue?.data?.toJson()}');
  Constants.token = loginCacheValue?.data?.token ?? '';
  // ConstantsModels.advertiseModel = AdvertiseModel.fromJson(jsonDecode(await userCache!.get(advertiseModelKey, defaultValue: '{}')));
  // ConstantsModels.categoriesModel = CategoriesModel.fromJson(jsonDecode(await userCache!.get(categoriesModelKey, defaultValue: '{}')));
  // ConstantsModels.allMyAddresses = AllMyAddresses.fromJson(jsonDecode(await userCache!.get(allMyAddressesKey, defaultValue: '{}')));
  Constants.fcmToken = await loginCache?.get(fcmTokenKey, defaultValue: '');
  Constants.deviceId = await loginCache?.get(deviceIdKey, defaultValue: '');

  arabicLanguage = await userCache?.get(languageAppKey, defaultValue: false);
  log('arabicLanguage ==>$arabicLanguage');
  Constants.fontFamily = arabicLanguage ? 'Cairo' : 'Cairo';
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationUtility.initializeAwesomeNotification();
  // Apply immersive navigation bar flags on Android via MethodChannel
  try {
    const platform = MethodChannel('com.codgoo.rova_star/ui');
    await platform.invokeMethod('setImmersiveMode');
  } catch (e) {
    // ignore errors silently
  }
  try {
    Constants.messageGlobal = await FirebaseMessaging.instance.getInitialMessage();
    if (Constants.messageGlobal?.data != null) {
      appStartScreen = const NavigationViewWithThemes();
    }
    log('appStartScreen $appStartScreen');
  } catch (error) {
    log('$error');
  }
  // rootBundle.loadString('assets/services/map.json').then((string) {
  //   Constants.mapStyleString = string;
  // });

  //Constants.jsonServerKey = await loadJsonFile();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'SA'),
        ],
        path: 'assets/translation',
        startLocale: const Locale('ar', 'SA'),
        child: DevicePreview(
          // ignore: avoid_redundant_argument_values
          enabled: false,
          //enabled: !kReleaseMode,
          builder: (context) => const MyApp(), // Wrap your app
        ),
      ),
    );
  });
}
