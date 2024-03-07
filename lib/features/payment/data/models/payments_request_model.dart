class PaymentsRequestModel {
  String? amount;
  String? cardNumber;
  String? clientName;
  String? fromCreationTimestamp;
  String? fromResponseTimestamp;
  String? id;
  String? responseCode;
  String? responseDescription;
  String? rrn;
  String? sequance;
  String? sorting;
  String? terminalId;
  String? toCreationTimestamp;
  String? toResponseTimestamp;
  String? type;
  List<String>? status;

  PaymentsRequestModel(
      {
        this.amount,
        this.cardNumber,
        this.clientName,
        this.fromCreationTimestamp,
        this.fromResponseTimestamp,
        this.id,
        this.responseCode,
        this.responseDescription,
        this.rrn,
        this.sequance,
        this.sorting,
        this.terminalId,
        this.toCreationTimestamp,
        this.toResponseTimestamp,
        this.type,
        this.status,
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['cardNumber'] = cardNumber;
    data['clientName'] = clientName;
    data['fromCreationTimestamp'] = fromCreationTimestamp;
    data['fromResponseTimestamp'] = fromResponseTimestamp;
    data['id'] = id;
    data['responseCode'] = responseCode;
    data['responseDescription'] = responseDescription;
    data['rrn'] = rrn;
    data['sequance'] = sequance;
    data['sorting'] = sorting;
    data['terminalId'] = terminalId;
    data['toCreationTimestamp'] = toCreationTimestamp;
    data['toResponseTimestamp'] = toResponseTimestamp;
    data['type'] = type;
    data['status'] = status;
    return data;
  }

}
