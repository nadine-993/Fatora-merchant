import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/constants/constants.dart';
import 'package:fatora/features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_styles.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';

class LanguageSelector extends StatefulWidget {
  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  bool _isArabicSelected = false;
  bool _isEnglishSelected = false;

  static final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    _getSelectedLanguage();
    super.initState();
  }

  _getSelectedLanguage() {
    String lang = _appPreferences.getLanguage();
    if(lang == 'ar') {
      _isArabicSelected = true;
    }
    else {
      _isEnglishSelected = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text('العربية', style: AppStyles.title,),
          value: _isArabicSelected,
          onChanged: (value) {
            setState(() {
              _isArabicSelected = value!;
              context.setLocale(Constants.languages['ar']!);
              _appPreferences.setLanguage('ar');
              _isEnglishSelected = !value;
            });
            //Navigation.pushReplacement(context, const SplashScreen());
          },
        ),
        CheckboxListTile(
          title: Text('English', style: AppStyles.title,),
          value: _isEnglishSelected,
          onChanged: (value) {
            setState(() {
              context.setLocale(Constants.languages['en']!);
              _appPreferences.setLanguage('en');
              _isEnglishSelected = value!;
              _isArabicSelected = !value;
            });
            //Navigation.pushReplacement(context, const SplashScreen());
          },
        ),
      ],
    );
  }
}
