import 'dart:convert';

import '../../../../core/api/core_models/base_result_model.dart';

class NotificationModel extends BaseResultModel{
  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.type,
    this.isRead,
    this.terminalId,
    this.sendDate,
  });

  int? id;
  String? title;
  String? body;
  String? type;
  bool? isRead;
  String? terminalId;
  String? sendDate;
  factory NotificationModel.fromRawJson(String str) => NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"],
    title: json["title"],
    body : json["body"],
    type : json["type"],
    isRead : json["isRead"],
    terminalId : json["terminalId"],
    sendDate : json["sendDate"],
  );



  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "type": type,
    "isRead": isRead,
    "terminalId": terminalId,
    "sendDate": sendDate,
  };

}