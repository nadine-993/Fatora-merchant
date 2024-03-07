import 'package:http/http.dart' as http;
import 'package:fatora/core/api/core_models/empty_model.dart';
import 'package:fatora/features/settings/data/models/change_password_request_model.dart';

import '../../../../core/api/core_models/base_result_model.dart';
import '../../../../core/api/data_source/remote_data_source.dart';
import '../../../../core/api/http/api_urls.dart';
import '../../../../core/api/http/http_method.dart';
import '../../data/models/check_update_response_model.dart';
import '../../data/models/get_default_params_response.dart';
import '../../data/models/set_default_params_request.dart';

class SettingsRepository {
  /// Get Default Parameters for the user
  static Future<BaseResultModel?> getDefaultParams() async {
    final res = await RemoteDataSource.request<GetDefaultParamsResponse>(
        converter: (json) => GetDefaultParamsResponse.fromJson(json),
        method: HttpMethod.post,
        withAuthentication: true,
        url: ApiURLs.getDefaultParams);
    return res;
  }

  /// Sets Default Parameters for the user
  static Future<BaseResultModel?> setDefaultParams(
      SetDefaultParamsRequest setDefaultParamsRequest) async {
    final res = await RemoteDataSource.request<EmptyModel>(
        converter: (json) => EmptyModel.fromJson(json),
        data: setDefaultParamsRequest.toJson(),
        method: HttpMethod.post,
        withAuthentication: true,
        url: ApiURLs.setDefaultParams);
    return res;
  }

  /// Gets privacy policy
  static Future<String?> getPrivacyPolicy(String lang) async {
    final response = await http.get(Uri.parse('${ApiURLs.getPrivacyPolicy}?lang=$lang'));

    if (response.statusCode == 200) {
      final htmlString = response.body;
      // Do something with the HTML string, such as displaying it in a WebView
      return htmlString;
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  /// Sets Default Parameters for the user
  static Future<BaseResultModel?> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    final res = await RemoteDataSource.request<EmptyModel>(
        converter: (json) => EmptyModel.fromJson(json),
        data: changePasswordRequest.toJson(),
        method: HttpMethod.post,
        withAuthentication: true,
        url: ApiURLs.changePassword);
    return res;
  }

  /// Gets if there is a new update to the application
  static Future<BaseResultModel?> checkUpdate(
      String version) async {
    final res = await RemoteDataSource.request<CheckUpdateResponseModel>(
        converter: (json) => CheckUpdateResponseModel.fromJson(json),
        queryParameters: {'version' : version},
        method: HttpMethod.get,
        withAuthentication: true,
        url: ApiURLs.checkUpdate);
    return res;
  }
}
