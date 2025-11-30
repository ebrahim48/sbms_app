import 'dart:convert';

ProductListModel productListModelFromJson(String str) => ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) => json.encode(data.toJson());

class ProductListModel {
  final List<ProductInfo>? productInfo;

  ProductListModel({
    this.productInfo,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
    productInfo: json["product_info"] == null ? [] : List<ProductInfo>.from(json["product_info"]!.map((x) => ProductInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product_info": productInfo == null ? [] : List<dynamic>.from(productInfo!.map((x) => x.toJson())),
  };
}

class ProductInfo {
  final int? id;
  final String? productName;

  ProductInfo({
    this.id,
    this.productName,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
    id: json["id"],
    productName: json["product_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
  };
}
