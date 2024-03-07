import 'package:fatora/features/advertisment/data/advertisment_response_model.dart';
import 'package:flutter/foundation.dart';

import '../../../core/api/data_source/remote_data_source.dart';
import '../../../core/api/http/api_urls.dart';
import '../../../core/api/http/http_method.dart';
import '../../../core/api/core_models/base_result_model.dart';

class AdvertisementRepository {
  static Future<BaseResultModel?> getAdvertisements() async {
    var res;
    try {
      res = await RemoteDataSource.request<AdvertisementsResponseModel>(
          converter: (json) => AdvertisementsResponseModel.fromJson(json),
          method: HttpMethod.get,
          withAuthentication: true,
          url: ApiURLs.getAdvertisement);
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }
}