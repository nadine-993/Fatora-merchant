class PayWithOtpRequestModel {
  int? clientId;
  String? language;
  String? terminalId;
  String? paymentId;
  String? otp;
  String? session;



  PayWithOtpRequestModel(
      {
        this.clientId,
        this.language,
        this.terminalId,
        this.paymentId,
        this.otp,
        this.session
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['language'] = language;
    data['terminalId'] = terminalId;
    data['paymentId'] = paymentId;
    data['otp'] = otp;
    data['sessionId'] = session;

    return data;
  }
}
