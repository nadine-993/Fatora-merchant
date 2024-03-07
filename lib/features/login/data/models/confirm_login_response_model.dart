import 'package:fatora/core/api/core_models/base_result_model.dart';

class ConfirmOtpResponseModel extends BaseResultModel {
  int? userId;
  String? passwordResetCode;

  ConfirmOtpResponseModel(
      {
        this.userId,
        this.passwordResetCode,
      });

  ConfirmOtpResponseModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? '';
    passwordResetCode = json['passwordResetCode'] ?? '';
  }
}