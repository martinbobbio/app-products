import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {

    String id;
    String title;
    double value;
    bool available;
    String photo;

    ProductModel({
        this.id,
        this.title = '',
        this.value  = 0.0,
        this.available = true,
        this.photo,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => new ProductModel(
        id: json["id"],
        title: json["title"],
        value: json["value"],
        available: json["available"],
        photo: json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "available": available,
        "photo": photo,
    };
}