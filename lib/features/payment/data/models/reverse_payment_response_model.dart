import '../../../../core/api/core_models/base_result_model.dart';

class ReversePaymentResponse extends BaseResultModel{
  int? code;
  String? response;

  ReversePaymentResponse(
      {
        this.code,
        this.response,
      });

  ReversePaymentResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    response = json['response'];
  }
}



