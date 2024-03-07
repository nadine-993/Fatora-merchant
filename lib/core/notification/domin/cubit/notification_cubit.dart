import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/notification/data/fcm_notification_model.dart';
import '../../../../core/notification/domin/notification_middleware.dart';
import 'package:flutter/material.dart';

import 'dart:io' show Platform;

import '../../../api/core_models/empty_model.dart';
import '../../notification.dart';
import '../repository/notification_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  static Future<bool> updateFCMToken(String? token) async {
    var response = await NotificationRepository.updateFCMToken(token);
    return response is EmptyModel;
  }

  static Future<bool> removeFCMToken() async {
    var response = await NotificationRepository.updateFCMToken(null);
    return response is EmptyModel;
  }

}
