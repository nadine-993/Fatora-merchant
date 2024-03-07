import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class AppSettings {

  //static const String BASE_URL = 'https://clinic-dev.dev.itland-sy.com';

  // static const String BASE_URL = 'https://clinic-stg.dev.itland-sy.com';
  static const String baseUrl = 'https://fmp-t.fatora.me/api';

  static const String apkUrl = '';
  static const String version = '';

/*
  static showUpdatePopup(){
    showCupertinoModalPopup<void>(
      context: Keys.navigatorKey.currentContext!,
      builder: (BuildContext context) => CupertinoActionSheet(
        title:   Text('Settings'.tr()),
        message:  Text(APP_NAME+ ' $VERSION'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child:  Text('Update Application'.tr()),
            onPressed: () {
              Navigator.pop(context);
              upgradeFromUrl();

            },
          ),

        ],
        cancelButton: CupertinoActionSheetAction(
          child:  Text("Cancel".tr() ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  static void
  upgradeFromUrl() async {
    launch("https://play.google.com/store/apps/details?id=" + "com.itland.clinic.clinic_patients"); }*/
}
