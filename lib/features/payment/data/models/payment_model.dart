import 'dart:convert';

import 'package:fatora/core/api/core_models/base_result_model.dart';

class Payment extends BaseResultModel{

  Payment({
    this.id,
    this.clientName,
    this.sequance,
    this.rrn,
    this.notes,
    this.amount,
    this.terminalId,
    this.cardNumber,
    this.status,
    this.type,
    this.creationTimestamp,
    this.responseTimestamp,
    this.responseCode,
    this.responseDescription,
    this.arPaymentLink,
    this.enPaymentLink,
  });

  String? id;
  String? clientName;
  String? sequance;
  String? rrn;
  String? notes;
  double? amount;
  String? terminalId;
  String? cardNumber;
  String? status;
  String? type;
  String? creationTimestamp;
  String? responseTimestamp;
  String? responseCode;
  String? responseDescription;
  String? arPaymentLink;
  String? enPaymentLink;
  factory Payment.fromRawJson(String str) => Payment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json["id"],
    clientName : json["clientName"],
    sequance : json["sequance"],
    rrn : json["rrn"],
    notes: json["notes"],
    amount : json["amount"] == "Infinity" ? 0 : json["amount"],
    terminalId : json["terminalId"],
    cardNumber : json["cardNumber"],
    status : json["status"],
    type : json["type"],
    creationTimestamp : json["creationTimestamp"],
    responseTimestamp : json["responseTimestamp"],
    responseCode : json["responseCode"],
    responseDescription : json["responseDescription"],
    arPaymentLink : json["arPaymentLink"],
    enPaymentLink : json["enPaymentLink"],
  );



  Map<String, dynamic> toJson() => {
    "id": id,
    "clientName": clientName,
    "sequance": sequance,
    "rrn": rrn,
    "notes": notes,
    "amount": amount,
    "terminalId": terminalId,
    "cardNumber": cardNumber,
    "status": status,
    "type": type,
    "creationTimestamp": creationTimestamp,
    "responseTimestamp": responseTimestamp,
    "responseCode": responseCode ,
    "responseDescription":responseDescription ,
    "arPaymentLink":arPaymentLink ,
    "enPaymentLink":enPaymentLink ,
  };
}