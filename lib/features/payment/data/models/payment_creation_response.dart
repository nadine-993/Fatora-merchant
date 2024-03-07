import '../../../../core/api/core_models/base_result_model.dart';

class PaymentCreationResponse extends BaseResultModel{
  int? code;
  PaymentResponse? response;

  PaymentCreationResponse(
      {
        this.code,
        this.response,
      });

  PaymentCreationResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    response = PaymentResponse.fromJson(json['response']);
  }
}

class PaymentResponse {
  String? paymentId;
  String? paymentLink;

  PaymentResponse({
    this.paymentId,
    this.paymentLink
  });

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'] ?? '';
    paymentLink = json['paymentLink'] ?? '';
  }
}

