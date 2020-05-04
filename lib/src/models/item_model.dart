// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

ItemModel itemModelFromJson(String str) => ItemModel.fromJson(json.decode(str));

String itemModelToJson(ItemModel data) => json.encode(data.toJson());

class ItemModel {
  String id;
  String title;
  double price;
  bool available;
  String photoUrl;

  ItemModel({
    this.id,
    this.title      = "",
    this.price      = 0.0,
    this.available  = true,
    this.photoUrl,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id          : json["id"],
    title       : json["title"],
    price       : json["price"].toDouble(),
    available   : json["available"],
    photoUrl    : json["photo_url"],
  );

  Map<String, dynamic> toJson() => {
//    "id"        : id,
    "title"     : title,
    "price"     : price,
    "available" : available,
    "photo_url" : photoUrl,
  };
}
