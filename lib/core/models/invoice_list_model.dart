import 'dart:convert';

InvoiceListModel invoiceListModelFromJson(String str) => InvoiceListModel.fromJson(json.decode(str));

String invoiceListModelToJson(InvoiceListModel data) => json.encode(data.toJson());

class InvoiceListModel {
  final String? invoiceLabel;
  final String? invoiceValue;
  final int? dueAmount;

  InvoiceListModel({
    this.invoiceLabel,
    this.invoiceValue,
    this.dueAmount,
  });

  factory InvoiceListModel.fromJson(Map<String, dynamic> json) => InvoiceListModel(
    invoiceLabel: json["invoice_label"],
    invoiceValue: json["invoice_value"],
    dueAmount: json["due_amount"],
  );

  Map<String, dynamic> toJson() => {
    "invoice_label": invoiceLabel,
    "invoice_value": invoiceValue,
    "due_amount": dueAmount,
  };
}

