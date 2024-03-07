import '../../../../core/api/core_models/base_result_model.dart';

class LoginResponseModel extends BaseResultModel {
  String? accessToken;

  LoginResponseModel(
      {
        this.accessToken,
      });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'] ?? '';
  }
}

