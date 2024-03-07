import '../../../../core/api/core_models/base_result_model.dart';

class VerifyUsernameResponseModel extends BaseResultModel {
  bool? firstLogin;

  VerifyUsernameResponseModel(
      {
        this.firstLogin,
      });

  VerifyUsernameResponseModel.fromJson(Map<String, dynamic> json) {
    firstLogin = json['firstLogin'] ?? '';
  }
}