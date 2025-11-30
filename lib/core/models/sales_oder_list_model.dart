import 'dart:convert';

// For parsing a list of sales orders
List<SalesOrderListModel> salesOrderListModelFromJson(String str) =>
    List<SalesOrderListModel>.from(json.decode(str).map((x) => SalesOrderListModel.fromJson(x)));

String salesOrderListModelToJson(List<SalesOrderListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesOrderListModel {
  final int? id;
  final String? userName;
  final String? createdAt;
  final String? dealerName;
  final String? warehouseName;
  final String? invoiceNo;
  final String? orderDate;
  final int? orderStatus;
  final String? orderStatusText;
  final String? totalQty;
  final String? grandTotal;
  final dynamic dealerType;
  final String? narration;

  SalesOrderListModel({
    this.id,
    this.userName,
    this.createdAt,
    this.dealerName,
    this.warehouseName,
    this.invoiceNo,
    this.orderDate,
    this.orderStatus,
    this.orderStatusText,
    this.totalQty,
    this.grandTotal,
    this.dealerType,
    this.narration,
  });

  factory SalesOrderListModel.fromJson(Map<String, dynamic> json) => SalesOrderListModel(
    id: json["id"],
    userName: json["user_name"],
    createdAt: json["created_at"],
    dealerName: json["dealer_name"],
    warehouseName: json["warehouse_name"],
    invoiceNo: json["invoice_no"],
    orderDate: json["order_date"],
    orderStatus: json["order_status"],
    orderStatusText: json["order_status_text"],
    totalQty: json["total_qty"],
    grandTotal: json["grand_total"],
    dealerType: json["dealer_type"],
    narration: json["narration"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_name": userName,
    "created_at": createdAt,
    "dealer_name": dealerName,
    "warehouse_name": warehouseName,
    "invoice_no": invoiceNo,
    "order_date": orderDate,
    "order_status": orderStatus,
    "order_status_text": orderStatusText,
    "total_qty": totalQty,
    "grand_total": grandTotal,
    "dealer_type": dealerType,
    "narration": narration,
  };
}