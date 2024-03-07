import 'dart:convert';

class Advertisement {

  int? id;
  String? name;
  String? description;
  String? image;
  String? link;
  int? order;
  int? duration;
  String? fromDate;
  String? toDate;

  Advertisement({
    this.id,
    this.name,
    this.description,
    this.image,
    this.link,
    this.order,
    this.duration,
    this.fromDate,
    this.toDate,
});

  factory Advertisement.fromRawJson(String str) => Advertisement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
    id: json["id"],
    name : json["name"],
    description : json["description"],
    image : json["image"],
    link : json["url"],
    order : json["order"],
    duration : json["duration"],
    fromDate : json["fromDate"],
    toDate : json["toDate"],
  );



  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
    "link": link,
    "order": order,
    "duration": duration,
    "fromDate": fromDate,
    "toDate": toDate,
  };

}