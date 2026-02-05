import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // main colors
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey,
    splashColor: ColorManager.lightPrimary,
    scaffoldBackgroundColor: ColorManager.white,

    // cardview theme
    cardTheme: CardThemeData(
        color: ColorManager.white,
        shadowColor: ColorManager.grey,
        elevation: AppSize.s1),

    // app bar theme
    appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.lightPrimary, // Navigation bar
        ),
        centerTitle: true,
        color: ColorManager.primary,
        elevation: AppSize.s0,
        shadowColor: ColorManager.lightPrimary,
        titleTextStyle: getRegularStyle(
            fontSize: FontSizeManager.s12, color: ColorManager.white)),

    // button theme
    buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        disabledColor: ColorManager.grey,
        buttonColor: ColorManager.primary,
        splashColor: ColorManager.lightPrimary),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: getRegularStyle(
                color: ColorManager.white, fontSize: FontSizeManager.s16),
            backgroundColor: ColorManager.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s12)))),

    // text theme
    textTheme: TextTheme(

        // use for home view Sub titles
        displayLarge: getBoldStyle(
            color: ColorManager.displayLarge, fontSize: FontSizeManager.s18),

        // use for tab selected style
        headlineLarge: getSemiBoldStyle(
            color: ColorManager.white, fontSize: FontSizeManager.s16),

        // use for tab unselected style
        headlineMedium: getMediumStyle(
            color: ColorManager.white, fontSize: FontSizeManager.s12),

        // use for news widget style
        titleMedium: getBoldStyleWithOverFlow(
            color: ColorManager.white,
            fontSize: FontSizeManager.s12,
            overflow: TextOverflow.ellipsis),

        // use for news widget style
        titleSmall: getBoldStyle(
            color: ColorManager.white, fontSize: FontSizeManager.s12),

        // use for breaking news style
        bodyLarge: getSemiBoldStyle(
            color: ColorManager.primary, fontSize: FontSizeManager.s12),

        //use for breaking news word
        bodySmall: getBoldStyle(
            color: ColorManager.error, fontSize: FontSizeManager.s12),

        //use for news date
        bodyMedium: getBoldStyle(
            color: ColorManager.primary, fontSize: FontSizeManager.s18),

        //use for news description
        labelSmall: getBoldStyle(
            color: ColorManager.grey, fontSize: FontSizeManager.s14)),
  );
}
