import '../../../../core/api/core_models/base_result_model.dart';

class SetPasswordResponseModel extends BaseResultModel {
  bool? canLogin;
  String? userName;

  SetPasswordResponseModel(
      {
        this.canLogin,
        this.userName,
      });

  SetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    canLogin = json['canLogin'] ?? '';
    userName = json['userName'] ?? '';
  }
}