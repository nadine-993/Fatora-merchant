import 'dart:convert';

class Client {

  Client({
    this.id,
    this.name,
    this.image,
  });

  int? id;
  String? name;
  String? image;
  factory Client.fromRawJson(String str) => Client.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    name : json["name"],
    image : json["image"],
  );



  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}