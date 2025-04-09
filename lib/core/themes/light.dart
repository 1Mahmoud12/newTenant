import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mamlaka/core/themes/colors.dart';
import 'package:mamlaka/core/themes/styles.dart';

class Themes {
  String family;

  Themes(this.family);

  ThemeData light() => ThemeData(
        scaffoldBackgroundColor: AppColors.scaffoldBackGround,
        cardColor: Colors.white,
        fontFamily: family,
        primaryColor: AppColors.primaryColor,
        dividerTheme: DividerThemeData(color: AppColors.transparent),
        appBarTheme: AppBarTheme(
          color: AppColors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.scaffoldBackGround,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.scaffoldBackGround,
            systemNavigationBarDividerColor: AppColors.scaffoldBackGround,
          ),
        ),
        cardTheme: CardTheme(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: AppColors.white,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyLarge: Styles.style24700.copyWith(color: AppColors.black, fontFamily: family),
              bodyMedium: Styles.style22700.copyWith(color: AppColors.black, fontFamily: family),
              bodySmall: Styles.style20700.copyWith(color: AppColors.black, fontFamily: family),
              titleLarge: Styles.style16700.copyWith(color: AppColors.black, fontFamily: family),
              titleMedium: Styles.style15400.copyWith(color: AppColors.black, fontFamily: family),
              titleSmall: Styles.style12400.copyWith(color: AppColors.black, fontFamily: family),
              labelLarge: Styles.style15700.copyWith(color: AppColors.black, fontFamily: family),
              labelMedium: Styles.style12400.copyWith(color: AppColors.black, fontFamily: family),
              labelSmall: Styles.style10400.copyWith(color: AppColors.black, fontFamily: family),
              displayLarge: Styles.style14400.copyWith(color: AppColors.lightTextColor, fontFamily: family),
              displayMedium: Styles.style14400.copyWith(color: AppColors.black, fontFamily: family),
              displaySmall: Styles.style18500.copyWith(color: AppColors.black, fontFamily: family),
              headlineLarge: Styles.style17600.copyWith(color: AppColors.black, fontFamily: family),
            ),
        dialogTheme: const DialogTheme(
          backgroundColor: AppColors.scaffoldBackGround,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.transparent,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primaryColor, // Custom cursor color
          selectionColor: AppColors.secondPrimaryColor, // Custom selection color
          selectionHandleColor: AppColors.primaryColor, // Custom selection handle color
        ),
      );

  ThemeData dark() => ThemeData(
        scaffoldBackgroundColor: AppColors.black,
        fontFamily: family,
        dividerTheme: DividerThemeData(color: AppColors.transparent),
        appBarTheme: AppBarTheme(
          color: AppColors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: AppColors.primaryColor, statusBarIconBrightness: Brightness.light),
        ),
        cardTheme: CardTheme(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: AppColors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: Styles.style24700.copyWith(color: AppColors.white, fontFamily: family),
          bodyMedium: Styles.style22700.copyWith(color: AppColors.white, fontFamily: family),
          bodySmall: Styles.style20700.copyWith(color: AppColors.white, fontFamily: family),
          titleLarge: Styles.style16700.copyWith(color: AppColors.white, fontFamily: family),
          titleMedium: Styles.style15400.copyWith(color: AppColors.white, fontFamily: family),
          titleSmall: Styles.style12400.copyWith(color: AppColors.white, fontFamily: family),
          labelLarge: Styles.style15700.copyWith(color: AppColors.white, fontFamily: family),
          labelMedium: Styles.style12400.copyWith(color: AppColors.white, fontFamily: family),
          labelSmall: Styles.style10400.copyWith(color: AppColors.white, fontFamily: family),
          displayLarge: Styles.style14400.copyWith(color: AppColors.lightTextColor, fontFamily: family),
          displayMedium: Styles.style14400.copyWith(color: AppColors.white, fontFamily: family),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.black,
        ),
      );
}
