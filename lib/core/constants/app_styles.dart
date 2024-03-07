import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/di.dart';
import '../utils/shared_perefrences/shared_perefrences_helper.dart';

class AppStyles {
  static final AppPreferences _appPreferences = instance<AppPreferences>();


  static const String poppins =   'Poppins';
  static const String dinNext =   'DinNext';
  static  String lang = _appPreferences.getLanguage();
  static String font = lang == 'en' ? poppins : dinNext;

  static TextStyle headline =  TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.4,
  );

  static TextStyle title =  TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: font,
    fontWeight: FontWeight.normal,
    fontSize: 14,
    letterSpacing: 0.4,
  );

  static TextStyle body =  TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.normal,
    fontSize: 12,
    letterSpacing: 0.4,
  );
}