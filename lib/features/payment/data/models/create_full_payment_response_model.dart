import 'package:fatora/core/api/core_models/base_result_model.dart';

class CreateFullPaymentResponse extends BaseResultModel{
  String? paymentId;
  String? sessionId;


  CreateFullPaymentResponse(
      {
        this.paymentId, this.sessionId,
      });

  CreateFullPaymentResponse.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'] ?? '';
    sessionId = json['sessionId'] ?? '';

  }
}

