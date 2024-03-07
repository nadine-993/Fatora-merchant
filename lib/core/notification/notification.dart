import 'dart:convert';
import 'dart:io';

import 'package:fatora/core/constants/app_keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm/flutter_fcm.dart';
// import 'package:pusher_beams/pusher_beams.dart';

import '../../main.dart';
import '../utils/di.dart';
import '../utils/shared_perefrences/shared_perefrences_helper.dart';
import 'data/fcm_notification_model.dart';
import 'domin/cubit/notification_cubit.dart';
import 'domin/notification_middleware.dart';
import 'package:http/http.dart' as http;
class Messaging {
  static final AppPreferences _appPreferences =  instance<AppPreferences>();
  int _counter = 0;
  List<String?>? myList;
  static String? token;


  static deleteToken() {
    Messaging.token = null;
    FCM.deleteRefreshToken();
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationReceived(RemoteMessage message) async {
    await Firebase.initializeApp();

    var notification = FCMNotificationModel.fromJson(message.data);
    NotificationMiddleware.onReceived(notification);
  }

  @pragma('vm:entry-point')
  static initFCM() async {
    try {
      print("sameeerrrrr");
      await Firebase.initializeApp();
      await FCM.initializeFCM(

        withLocalNotification: true,
        navigatorKey: AppKeys.navigatorKey,
        onNotificationReceived: onNotificationReceived,
        onNotificationPressed: (Map<String, dynamic> data) {
          var notification = FCMNotificationModel.fromJson(data);
          NotificationMiddleware.forward(notification);

        },
        onTokenChanged: (String? token) {
          if (token != null) {
            Messaging.token = token;
            if (_appPreferences.hasAccessToken()) {
              NotificationCubit.updateFCMToken(Messaging.token);
              if (kDebugMode) {
                print('FCM Token  $token');
              }
            }
          }
        },

        // TODO add this icon to android/app/src/main/res/drawable/ic_launcher.png
        icon: 'ic_launcher',
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
