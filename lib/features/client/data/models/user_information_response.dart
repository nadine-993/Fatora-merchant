import 'dart:convert';

import 'package:fatora/core/api/core_models/base_result_model.dart';



class UserInformationResponse extends BaseResultModel{

  UserInformationResponse({
    this.user,
  });

  User? user;
  factory UserInformationResponse.fromRawJson(String str) => UserInformationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInformationResponse.fromJson(Map<String, dynamic> json) => UserInformationResponse(
    user: User.fromJson(json["user"]),
  );



  Map<String, dynamic> toJson() => {
    "user": user,
  };
}

class User {

  User({
    this.firstname,
    this.surname,
    this.userName,
    this.emailAddress,
    this.mobileNumber,
    this.currency,
  });

  String? firstname;
  String? surname;
  String? userName;
  String? emailAddress;
  String? mobileNumber;
  String? currency;
  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstname: json["name"],
    surname : json["surname"],
    userName : json["userName"],
    emailAddress : json["emailAddress"],
    mobileNumber : json["mobile_number"],
    currency : json["currency"],
  );



  Map<String, dynamic> toJson() => {
    "name": firstname,
    "surname": surname,
    "userName": userName,
    "mobile_number": mobileNumber,
    "currency": currency,
  };
}