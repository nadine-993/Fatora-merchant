import 'package:flutter/foundation.dart';

import '../../../../core/api/data_source/remote_data_source.dart';
import '../../../../core/api/http/api_urls.dart';
import '../../../../core/api/http/http_method.dart';
import '../../../../core/api/core_models/base_result_model.dart';
import '../../data/model/notification_list_response.dart';

class NotificationsRepo {
  /// Gets the list of notifications based on the terminal
  static Future<BaseResultModel> getNotifications(
      dynamic requestData,
      dynamic notificationsRequestModel,
      ) async {
    var res;
    Map<String, dynamic> map1 = requestData.toJson();
    Map<String, dynamic> map2 = notificationsRequestModel.toJson();
    Map<String, dynamic> combinedMap = {...map1, ...map2};
    try {
      res = await RemoteDataSource.request<NotificationListResponse>(
          converter: (json) => NotificationListResponse.fromJson(json),
          method: HttpMethod.post,
          data: combinedMap,
          withAuthentication: true,
          url: ApiURLs.getNotifications);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }
}