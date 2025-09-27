import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/themes/light.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/feature/cart/view/manager/cartItems/cubit/cart_items_cubit.dart';
import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:dobzz_seller/feature/navigation/view/manager/homeBloc/state.dart';
import 'package:dobzz_seller/mainCubit/cubit/main_cubit_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dobzz_seller_view.dart';
import 'feature/address/view/manager/address/cubit/address_cubit.dart';
import 'feature/auth/manager/authBloc/auth_cubit.dart';
import 'feature/navigation/view/manager/homeBloc/cubit.dart';
import 'main.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    addressCubit.getAddress(context: context);
    super.initState();
  }

  AddressCubit addressCubit = AddressCubit();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeCubit(),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => AuthCubit()..getCountryCode(),
          ),
          BlocProvider(
            create: (context) => MainCubitCubit(),
          ),

          BlocProvider(
            create: (context) => CartItemsCubit(),
          ),
          BlocProvider(
            create: (context) => WishListCubit()..getWishList(context: context),
          ),
          // BlocProvider(
          //   create: (context) => ManageAddressesCubit(),
          // ),
          // BlocProvider(
          //   create: (context) => ProceedCubit(),
          // ),
          // BlocProvider(
          //   create: (context) => CartCubit(),
          // ),
        ],
        child: BlocBuilder<WishListCubit, WishListState>(
          buildWhen: (previous, current) => current is WishListSuccess,
          builder: (context, state) => BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              SystemChrome.setSystemUIOverlayStyle(
                const SystemUiOverlayStyle(
                  statusBarColor: AppColors.scaffoldBackGround,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                  systemNavigationBarColor: AppColors.scaffoldBackGround,
                  systemNavigationBarDividerColor: AppColors.scaffoldBackGround,
                ),
              );
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                //locale: DevicePreview.locale(context),
                //builder: DevicePreview.appBuilder,
                navigatorKey: navigatorKey,
                theme: Themes(Constants.fontFamily).light(),
                darkTheme: Themes(Constants.fontFamily).dark(),
                themeMode: darkModeValue ? ThemeMode.dark : ThemeMode.light,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(),
                  child: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: const SystemUiOverlayStyle(
                      statusBarColor: AppColors.scaffoldBackGround,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                    ),
                    child: SafeArea(
                      top: false,
                      child: child ?? const SizedBox(),
                    ),
                  ),
                ),
                navigatorObservers: [
                  HeroController(
                    createRectTween: (begin, end) {
                      return SlowRectTween(begin: begin, end: end);
                    },
                  ),
                ],
                home: const DobzzSellerApp(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SlowRectTween extends RectTween {
  SlowRectTween({super.begin, super.end});

  @override
  Rect lerp(double t) {
    // Apply easing curve to slow down animation
    final slowT = Curves.easeInOut.transform(t); // or use Interval(0.0, 0.5)
    return Rect.lerp(begin, end, slowT)!;
  }
}
