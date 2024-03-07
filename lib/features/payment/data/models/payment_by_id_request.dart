class PaymentByIdRequest {
  String? id;

  PaymentByIdRequest({this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentId'] = id;
    return data;
  }

}


