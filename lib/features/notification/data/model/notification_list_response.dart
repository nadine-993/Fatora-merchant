import 'dart:convert';

import 'package:fatora/features/notification/data/model/notification_model.dart';


import '../../../../core/api/core_models/base_result_model.dart';



class NotificationListResponse extends ListResultModel<NotificationModel>{
  NotificationListResponse({
    required this.list,
    this.totalCount,
  });

  late List<NotificationModel> list;
  int? totalCount;

  factory NotificationListResponse.fromRawJson(String str) => NotificationListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) => NotificationListResponse(
    list: List<NotificationModel>.from(json["items"].map((x) => NotificationModel.fromJson(x))),
    totalCount: json["totalCount"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(list!.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}



