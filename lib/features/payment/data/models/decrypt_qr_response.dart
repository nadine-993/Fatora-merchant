import 'package:fatora/core/api/core_models/base_result_model.dart';

class DecryptQrResponse extends BaseResultModel{
  String? cardNumber;
  String? expiryDate;
  String? holderName;

  DecryptQrResponse(
      this.holderName,
      this.cardNumber,
      this.expiryDate,

      );

  DecryptQrResponse.fromJson(Map<String, dynamic> json) {

    holderName = json['HN'] ?? '';
    cardNumber = json['CN'] ?? '';
    expiryDate = json['ED'] ?? '';
  }
}

