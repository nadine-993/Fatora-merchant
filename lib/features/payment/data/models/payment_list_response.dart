import 'dart:convert';

import 'package:fatora/features/payment/data/models/payment_model.dart';

import '../../../../core/api/core_models/base_result_model.dart';


class PaymentListResponse extends ListResultModel<Payment>{
  PaymentListResponse({
    required this.list,
    this.totalCount,
  });

  late List<Payment> list;
  int? totalCount;

  factory PaymentListResponse.fromRawJson(String str) => PaymentListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentListResponse.fromJson(Map<String, dynamic> json) => PaymentListResponse(
    list: List<Payment>.from(json["items"].map((x) => Payment.fromJson(x))),
    totalCount: json["totalCount"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(list!.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}



