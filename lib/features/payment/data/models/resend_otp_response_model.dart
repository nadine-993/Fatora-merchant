import '../../../../core/api/core_models/base_result_model.dart';

class ResendOtpResponse extends BaseResultModel{
  String? message;

  ResendOtpResponse(
      {
        this.message,
      });

  ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
  }
}

