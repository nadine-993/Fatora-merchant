import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppColors {
  static const Color white = Colors.white;
  static const Color black = Color(0xff333333);
  static const Color lightGray = Color(0xffF0F0F0);
  static const Color midGray = Color(0xffe4e4e4);
  static const Color darkGray = Color(0xffaeaeae);
  static const Color darkerGray = Color(0xff8d8d8d);

  static const Color primary = Color(0xff22366b);
  static const Color secondary = Color(0xff02b4ce);


  static const Color transparent = Colors.transparent;

  // Notifications
  static const Color notificationBg = Color(0xffeaf4f7);
  static const Color notificationBorder = Color(0xffd2ebea);

  static const Color red = Color(0xFFff4040);
  static const Color green = Color(0xFF3AB158);
  static const Color yellow = Color(0xFFfede00);

  // Statuses
  static const Color approved = Color(0xFFc8e6c9);
  static const Color pending = Color(0xFFffd8b2);
  static const Color cancelled = Color(0xFF922553);
  static const Color reversed = Color(0xFFeccfff);
  static const Color failed = Color(0xFFffcdd2);

  static const Color approvedBg = Color(0xFF256029);
  static const Color pendingBg = Color(0xFF805b36);
  static const Color cancelledBg = white;
  static const Color reversedBg = Color(0xFF694382);
  static const Color failedBg = Color(0xFFc63737);


  //Text Theme
  static const Color text = Color(0xFF101010);


  static const LinearGradient cardGradient = LinearGradient(colors: [
    AppColors.primary,
    AppColors.secondary,
  ]);

  static const LinearGradient cardGradientReversed = LinearGradient(colors: [
    AppColors.secondary,
    AppColors.primary,
  ]);



}
