import 'package:flutter/material.dart';

import '../utils/di.dart';
import '../utils/shared_perefrences/shared_perefrences_helper.dart';

class Constants {
  static final AppPreferences appPreferences = instance<AppPreferences>();

  static const APP_NAME = 'FMP Test';
  static const APP_VERSION = '1.0.14';

// Languages
  static String defaultLanguage = appPreferences.getLanguage();
  static const Map<String, Locale> languages = {
    'ar': Locale('ar'),
    'en': Locale('en'),
  };
  
  static DateTime defaultStartDate = DateTime.now().subtract(const Duration(days: 7));
  static DateTime defaultEndDate = DateTime.now();
}

