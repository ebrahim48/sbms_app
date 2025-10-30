import 'dart:convert';

InvoiceNumberModel invoiceNumberModelFromJson(String str) => InvoiceNumberModel.fromJson(json.decode(str));

String invoiceNumberModelToJson(InvoiceNumberModel data) => json.encode(data.toJson());

class InvoiceNumberModel {
  final int? invoiceNo;

  InvoiceNumberModel({
    this.invoiceNo,
  });

  factory InvoiceNumberModel.fromJson(Map<String, dynamic> json) => InvoiceNumberModel(
    invoiceNo: json["invoice_no"],
  );

  Map<String, dynamic> toJson() => {
    "invoice_no": invoiceNo,
  };
}
