import 'dart:convert';

import 'package:fatora/core/api/core_models/base_result_model.dart';

import 'advertisement_model.dart';

class AdvertisementsResponseModel extends BaseResultModel {

  List<Advertisement>? list;

  AdvertisementsResponseModel({
    this.list
});

  factory AdvertisementsResponseModel.fromRawJson(String str) => AdvertisementsResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdvertisementsResponseModel.fromJson(Map<String, dynamic> json) => AdvertisementsResponseModel(
    list: List<Advertisement>.from(json["items"].map((x) => Advertisement.fromJson(x))),
  );

  @override
  Map<String, dynamic> toJson() => {
    "": List<dynamic>.from(list!.map((x) => x.toJson())),
  };

}