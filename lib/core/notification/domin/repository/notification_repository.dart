
import '../../../api/data_source/remote_data_source.dart';
import '../../../api/http/api_urls.dart';
import '../../../api/http/http_method.dart';
import '../../../api/core_models/base_result_model.dart';
import '../../data/get_unread_notifications_response.dart';

class NotificationRepository {
  static Future<BaseResultModel?> updateFCMToken(String? token) async {
    var res = await RemoteDataSource.request<BaseResultModel>(
        converter: (json) => BaseResultModel.fromJson(json),
        method: HttpMethod.post,
        withAuthentication: true,
        data: {
          "token": token
        },
        url: ApiURLs.setFCMToken);
    print("Fatora , Fatora");
    return res;
  }

  static Future<BaseResultModel?> removeFCMToken(String? token) async {
    var res = await RemoteDataSource.request<BaseResultModel>(
        converter: (json) => BaseResultModel.fromJson(json),
        method: HttpMethod.post,
        withAuthentication: true,
        data: {
          "token": token
        },
        url: ApiURLs.removeFCMToken);
    return res;
  }

  static Future<BaseResultModel?> readNotification(int id) async {
    return await RemoteDataSource.request<BaseResultModel>(
        converter: (json) => BaseResultModel.fromJson(json),
        method: HttpMethod.post,
        withAuthentication: true,
        queryParameters: {'id': id},
        url: ApiURLs.readNotification);
  }

  static Future<BaseResultModel?> getUnreadNotifications(String terminalId) async {
    return await RemoteDataSource.request<GetUnreadNotificationsResponse>(
        converter: (json) => GetUnreadNotificationsResponse.fromJson(json),
        method: HttpMethod.get,
        queryParameters: {'terminalId': terminalId},
        withAuthentication: true,
        url: ApiURLs.getUnreadNotifications);
  }
}
