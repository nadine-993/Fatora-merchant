import 'dart:convert';

import 'package:fatora/core/api/core_models/base_result_model.dart';

class GetUnreadNotificationsResponse extends BaseResultModel{
  int? count;

  GetUnreadNotificationsResponse({
    this.count
});

  factory GetUnreadNotificationsResponse.fromRawJson(String str) => GetUnreadNotificationsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUnreadNotificationsResponse.fromJson(Map<String, dynamic> json) => GetUnreadNotificationsResponse(
    count: json["count"],
  );



  Map<String, dynamic> toJson() => {
    "count": count,
  };
}