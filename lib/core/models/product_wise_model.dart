
import 'dart:convert';

ProductWisePricetModel productWisePricetModelFromJson(String str) => ProductWisePricetModel.fromJson(json.decode(str));

String productWisePricetModelToJson(ProductWisePricetModel data) => json.encode(data.toJson());

class ProductWisePricetModel {
  final ProductPriceInfo? productInfo;

  ProductWisePricetModel({
    this.productInfo,
  });

  factory ProductWisePricetModel.fromJson(Map<String, dynamic> json) => ProductWisePricetModel(
    productInfo: json["product_info"] == null ? null : ProductPriceInfo.fromJson(json["product_info"]),
  );

  Map<String, dynamic> toJson() => {
    "product_info": productInfo?.toJson(),
  };
}

class ProductPriceInfo {
  final int? stock;
  final String? price;

  ProductPriceInfo({
    this.stock,
    this.price,
  });

  factory ProductPriceInfo.fromJson(Map<String, dynamic> json) => ProductPriceInfo(
    stock: json["stock"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "stock": stock,
    "price": price,
  };
}
