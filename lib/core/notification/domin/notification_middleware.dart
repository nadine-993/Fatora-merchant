import '../../constants/enums.dart';
import '../data/fcm_notification_model.dart';

class NotificationMiddleware {
  static forward(FCMNotificationModel notification) async {
    switch(notification.type){

      case NotificationType.NULL:
        break;
      default:
    }
  }

  static onReceived(FCMNotificationModel notification) async {}
}
