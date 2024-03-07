class CreateFullPaymentRequestModel {
  num? amount;
  String? callbackURL;
  int? clientId;
  String? lang;
  String? terminalId;
  String? triggerURL;
  String? notes;
  String? cardNumber;
  String? expiryDate;


  CreateFullPaymentRequestModel(
      {
        this.amount,
        this.callbackURL,
        this.clientId,
        this.lang,
        this.terminalId,
        this.triggerURL,
        this.notes,
        this.cardNumber,
        this.expiryDate,
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['callbackURL'] = callbackURL;
    data['clientId'] = clientId;
    data['lang'] = lang;
    data['terminalId'] = terminalId;
    data['triggerURL'] = triggerURL;
    data['notes'] = notes;
    data['cardNumber'] = cardNumber;
    data['expiryDate'] = expiryDate;
    return data;
  }
}
