import '../../../../core/api/core_models/base_result_model.dart';

class PayWithOtpResponse extends BaseResultModel{
  bool? paid;

  PayWithOtpResponse(
      {
        this.paid,
      });

  PayWithOtpResponse.fromJson(Map<String, dynamic> json) {
    paid = json['paid'] ?? '';
  }
}

