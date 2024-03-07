import 'package:fatora/core/api/core_models/base_result_model.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/api/data_source/remote_data_source.dart';
import '../../../../core/api/http/api_urls.dart';
import '../../../../core/api/http/http_method.dart';
import '../../data/models/client_response_model.dart';
import '../../data/models/get_my_permissions_response.dart';
import '../../data/models/user_information_response.dart';

class ClientRepository {
  static Future<BaseResultModel?> getAllUserClients() async {
    var res;
    try {
      res = await RemoteDataSource.request<ClientListResponse>(
          converter: (json) => ClientListResponse.fromJson(json),
          method: HttpMethod.post,
          withAuthentication: true,
          url: ApiURLs.getAllUserClients);
    }
    catch (e) {

        print(e);
    }
    return res;
  }

  static Future<BaseResultModel?> getMyPermissions() async {
    var res;
    try {
      res = await RemoteDataSource.request<GetMyPermissionsResponse>(
          converter: (json) => GetMyPermissionsResponse.fromJson(json),
          method: HttpMethod.get,
          withAuthentication: true,
          url: ApiURLs.getMyPermissions);
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }

  static Future<BaseResultModel?> getUserInformation() async {
    var res;
    try {
      res = await RemoteDataSource.request<UserInformationResponse>(
          converter: (json) => UserInformationResponse.fromJson(json),
          method: HttpMethod.get,
          withAuthentication: true,
          url: ApiURLs.getUserInformation);
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }
}
