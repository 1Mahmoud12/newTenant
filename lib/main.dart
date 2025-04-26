import 'dart:convert';
import 'dart:developer';
import 'package:device_preview/device_preview.dart';
import 'package:dobzz_seller/feature/splash/view/presentation/splash_screen.dart';
import 'package:dobzz_seller/mainCubit/cubit/main_cubit_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:dobzz_seller/core/utils/bloc_observe.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/feature/auth/data/models/register_model.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';
import 'core/network/dio_helper.dart';
import 'core/network/local/cache.dart';
import 'core/network/local/hive_data_base.dart';
import 'core/utils/notification/notification.dart';
import 'firebase_options.dart';
import 'my_app.dart';

//notification icon make it base color , the padding between product cards ,

Widget appStartScreen = const SplashScreen();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized(); // Add this line
  await ScreenUtil.ensureScreenSize();

  EasyLocalization.logger.enableBuildModes = [];
  // Hive
  await Hive.initFlutter();

  // Dio
  await DioHelper.init();

  userCache = await openHiveBox(userCacheBoxKey);
  // get device id
  final MainCubitCubit mainCubit = MainCubitCubit();
  Constants.deviceId = await mainCubit.getDeviceIdentifier() ?? '';
  log('deviceId ==>${Constants.deviceId}');

  onBoardingValue = userCache?.get(onBoardingKey, defaultValue: true);
  darkModeValue = userCache?.get(darkModeKey, defaultValue: false);
  locationCacheValue = userCache?.get(locationCacheKey);
  userCacheValue = RegisterModel.fromJson(jsonDecode(await userCache?.get(userCacheKey, defaultValue: '{}')));
  log('userCacheValue ==>$userCacheValue');
  log('userCacheValue.data ==>${userCacheValue?.data}');
  Constants.token = userCacheValue?.data?.token ?? '';
  // ConstantsModels.advertiseModel = AdvertiseModel.fromJson(jsonDecode(await userCache!.get(advertiseModelKey, defaultValue: '{}')));
  // ConstantsModels.categoriesModel = CategoriesModel.fromJson(jsonDecode(await userCache!.get(categoriesModelKey, defaultValue: '{}')));
  // ConstantsModels.allMyAddresses = AllMyAddresses.fromJson(jsonDecode(await userCache!.get(allMyAddressesKey, defaultValue: '{}')));
  Constants.fcmToken = await userCache?.get(fcmTokenKey, defaultValue: '');
  Constants.deviceId = await userCache?.get(deviceIdKey, defaultValue: '');

  arabicLanguage = await userCache?.get(languageAppKey, defaultValue: false);
  log('arabicLanguage ==>$arabicLanguage');
  Constants.fontFamily = arabicLanguage ? 'ALMAMLAKAFONT' : 'ALMAMLAKAFONT';
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationUtility.initializeAwesomeNotification();
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
  //selectTokens();
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
        startLocale: const Locale('en', 'US'),
        child: DevicePreview(
          // ignore: avoid_redundant_argument_values
          enabled: true,
          // enabled: false,
          builder: (context) => const MyApp(), // Wrap your app
        ),
      ),
    );
  });
}
