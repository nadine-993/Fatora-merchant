import 'package:dio/dio.dart';
import 'package:fatora/core/api/core_models/base_result_model.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/api/data_source/remote_data_source.dart';
import '../../../../core/api/http/api_urls.dart';
import '../../../../core/api/http/http_method.dart';
import '../../data/models/terminal_response_model.dart';

class TerminalRepository {
  static Future<BaseResultModel?> getAllClientTerminals(int? clientId) async {
    var res;
    try {
      res = await RemoteDataSource.request(
        converter: (json) => TerminalResponseModel.fromJson(json),
          method: HttpMethod.post,
          withAuthentication: true,
          queryParameters: {
            "clientId": clientId,
          },
          url: ApiURLs.getAllClientTerminals);
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }
}
