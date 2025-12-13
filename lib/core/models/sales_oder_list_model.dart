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
  final int? dealerCreditDuration;
  final String? orderStatusText;
  final String? totalQty;
  final String? totalDiscount;
  final String? grandTotal;
  final dynamic dealerType;
  final String? narration;
  final String? totalBonus;

  SalesOrderListModel({
    this.id,
    this.userName,
    this.createdAt,
    this.dealerName,
    this.warehouseName,
    this.dealerCreditDuration,
    this.invoiceNo,
    this.orderDate,
    this.orderStatus,
    this.orderStatusText,
    this.totalQty,
    this.totalDiscount,
    this.grandTotal,
    this.dealerType,
    this.narration,
    this.totalBonus,
  });

  factory SalesOrderListModel.fromJson(Map<String, dynamic> json) => SalesOrderListModel(
    id: json["id"] is int ? json["id"] : (json["id"] is String ? int.tryParse(json["id"]) : null),
    userName: json["user_name"] is String ? json["user_name"] : (json["user_name"]?.toString() ?? null),
    createdAt: json["created_at"] is String ? json["created_at"] : (json["created_at"]?.toString() ?? null),
    dealerName: json["dealer_name"] is String ? json["dealer_name"] : (json["dealer_name"]?.toString() ?? null),
    warehouseName: json["warehouse_name"] is String ? json["warehouse_name"] : (json["warehouse_name"]?.toString() ?? null),
    invoiceNo: json["invoice_no"] is String ? json["invoice_no"] : (json["invoice_no"]?.toString() ?? null),
    orderDate: json["order_date"] is String ? json["order_date"] : (json["order_date"]?.toString() ?? null),
    orderStatus: json["order_status"] is int ? json["order_status"] : (json["order_status"] is String ? int.tryParse(json["order_status"]) : json["order_status"]),
    dealerCreditDuration: json["dealer_credit_duration"] is int ? json["dealer_credit_duration"] : (json["dealer_credit_duration"] is String ? int.tryParse(json["dealer_credit_duration"]) : json["dealer_credit_duration"]),
    orderStatusText: json["order_status_text"] is String ? json["order_status_text"] : (json["order_status_text"]?.toString() ?? null),
    totalQty: json["total_qty"] is String ? json["total_qty"] : (json["total_qty"]?.toString() ?? null),
    totalDiscount: json["total_discount"] is String ? json["total_discount"] : (json["total_discount"]?.toString() ?? null),
    grandTotal: json["grand_total"] is String ? json["grand_total"] : (json["grand_total"]?.toString() ?? null),
    dealerType: json["dealer_type"],
    narration: json["narration"] is String ? json["narration"] : (json["narration"]?.toString() ?? null),
    totalBonus: json["total_bonus"] is String ? json["total_bonus"] : (json["total_bonus"]?.toString() ?? null),
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
    "total_discount": totalDiscount,
    "grand_total": grandTotal,
    "dealer_type": dealerType,
    "narration": narration,
    "dealer_credit_duration": dealerCreditDuration,
    "total_bonus": totalBonus,
  };
}