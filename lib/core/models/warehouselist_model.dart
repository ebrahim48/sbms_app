import 'dart:convert';

WareHouseListModel wareHouseListModelFromJson(String str) => WareHouseListModel.fromJson(json.decode(str));

String wareHouseListModelToJson(WareHouseListModel data) => json.encode(data.toJson());

class WareHouseListModel {
  final List<WarehouseInfo>? warehouseInfo;

  WareHouseListModel({
    this.warehouseInfo,
  });

  factory WareHouseListModel.fromJson(Map<String, dynamic> json) => WareHouseListModel(
    warehouseInfo: json["warehouse_info"] == null ? [] : List<WarehouseInfo>.from(json["warehouse_info"]!.map((x) => WarehouseInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "warehouse_info": warehouseInfo == null ? [] : List<dynamic>.from(warehouseInfo!.map((x) => x.toJson())),
  };
}

class WarehouseInfo {
  final int? id;
  final String? warehouseName;

  WarehouseInfo({
    this.id,
    this.warehouseName,
  });

  factory WarehouseInfo.fromJson(Map<String, dynamic> json) => WarehouseInfo(
    id: json["id"],
    warehouseName: json["warehouse_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "warehouse_name": warehouseName,
  };
}
