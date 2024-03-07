import 'package:fatora/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'app_colors.dart';
import 'app_values.dart';

class AppTheme {
  static final defaultPinTheme = PinTheme(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: AppColors.secondary,
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: AppColors.lightGray,
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: AppColors.primary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.transparent,
    titleTextStyle: const TextStyle(color: AppColors.black),
    iconTheme: const IconThemeData(color:  AppColors.black, size: AppSize.s24),
    toolbarTextStyle: AppStyles.headline,
    elevation: AppSize.s0,
    actionsIconTheme: const IconThemeData(color:  AppColors.black, size: AppSize.s30),
  ),
);



ThemeData getLightTheme() {
  return lightTheme;
}

