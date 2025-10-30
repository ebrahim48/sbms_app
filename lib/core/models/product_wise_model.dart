
import 'dart:convert';

ProductWisePricetModel productWisePricetModelFromJson(String str) => ProductWisePricetModel.fromJson(json.decode(str));

String productWisePricetModelToJson(ProductWisePricetModel data) => json.encode(data.toJson());

class ProductWisePricetModel {
  final ProductInfo? productInfo;

  ProductWisePricetModel({
    this.productInfo,
  });

  factory ProductWisePricetModel.fromJson(Map<String, dynamic> json) => ProductWisePricetModel(
    productInfo: json["product_info"] == null ? null : ProductInfo.fromJson(json["product_info"]),
  );

  Map<String, dynamic> toJson() => {
    "product_info": productInfo?.toJson(),
  };
}

class ProductInfo {
  final int? stock;
  final String? price;

  ProductInfo({
    this.stock,
    this.price,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
    stock: json["stock"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "stock": stock,
    "price": price,
  };
}
