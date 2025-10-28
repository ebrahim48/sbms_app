import 'dart:convert';

DealerInfoModel dealerInfoModelFromJson(String str) => DealerInfoModel.fromJson(json.decode(str));

String dealerInfoModelToJson(DealerInfoModel data) => json.encode(data.toJson());

class DealerInfoModel {
  final List<DealerInfo>? dealerInfo;

  DealerInfoModel({
    this.dealerInfo,
  });

  factory DealerInfoModel.fromJson(Map<String, dynamic> json) => DealerInfoModel(
    dealerInfo: json["dealer_info"] == null ? [] : List<DealerInfo>.from(json["dealer_info"]!.map((x) => DealerInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "dealer_info": dealerInfo == null ? [] : List<dynamic>.from(dealerInfo!.map((x) => x.toJson())),
  };
}

class DealerInfo {
  final int? id;
  final String? dealerName;

  DealerInfo({
    this.id,
    this.dealerName,
  });

  factory DealerInfo.fromJson(Map<String, dynamic> json) => DealerInfo(
    id: json["id"],
    dealerName: json["dealer_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dealer_name": dealerName,
  };
}
