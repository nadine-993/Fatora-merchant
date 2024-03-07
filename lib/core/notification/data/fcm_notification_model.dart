
import '../../constants/enums.dart';

class FCMNotificationModel {
  String? id;
  String? notificationName;
  NotificationType? type;
  String? message;
  String? dateTime;
  int? relatedId;
  NotificationType? state;

  FCMNotificationModel(
      {this.id,
      this.notificationName,
      this.type,
      this.message,
      this.dateTime,
      this.relatedId,
      this.state});

  FCMNotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['notificationName'] != null) {
      notificationName = json['notificationName'];
    }
    if (json['type'] != null) type = NotificationType.values[json['type']];
    if (json['message'] != null) {
      message = json['message'];
    }
    if (json['dateTime'] != null) {
      dateTime = json['dateTime'];
    }
    if (json['relatedId'] != null) {
      relatedId = json['relatedId'];
    }
  }

  FCMNotificationModel.fromFCM(Map<String, dynamic> json) {
    if (json['type'] != null) {
      type = NotificationType.values[int.parse(json['type'])];
    }
    if (json['relatedId'] != null) {
      relatedId = int.parse(json['relatedId']);
    }
    if (json['time'] != null) {
      dateTime = json['time'];
    }
  }

  FCMNotificationModel.fromSignalR(Map<String, dynamic> json) {}
}
