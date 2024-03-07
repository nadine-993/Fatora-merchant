class ConfirmReverseRequestModel {
  String? paymentId;
  String? otp;


  ConfirmReverseRequestModel(
      {
        this.paymentId,
        this.otp,
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentId'] = paymentId;
    data['otp'] = otp;

    return data;
  }
}
