import 'dart:convert';

import '../../../../core/api/core_models/base_result_model.dart';
import 'client_model.dart';


class ClientListResponse extends ListResultModel<Client>{
  ClientListResponse({
    required this.list,
    this.totalCount,
  });

  late List<Client> list;
  int? totalCount;

  factory ClientListResponse.fromRawJson(String str) => ClientListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientListResponse.fromJson(Map<String, dynamic> json) => ClientListResponse(
    list: List<Client>.from(json["items"].map((x) => Client.fromJson(x))),
    totalCount: json["totalCount"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(list!.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}



