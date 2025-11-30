

import 'dart:convert';

BankReceiveListModel bankReceiveListModelFromJson(String str) => BankReceiveListModel.fromJson(json.decode(str));

String bankReceiveListModelToJson(BankReceiveListModel data) => json.encode(data.toJson());

class BankReceiveListModel {
  final int? id;
  final String? userName;
  final DateTime? createdAt;
  final String? bankName;
  final String? dSName;
  final DateTime? paymentDate;
  final String? invoice;
  final String? amount;

  BankReceiveListModel({
    this.id,
    this.userName,
    this.createdAt,
    this.bankName,
    this.dSName,
    this.paymentDate,
    this.invoice,
    this.amount,
  });

  factory BankReceiveListModel.fromJson(Map<String, dynamic> json) => BankReceiveListModel(
    id: json["id"],
    userName: json["user_name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    bankName: json["bank_name"],
    dSName: json["d_s_name"],
    paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
    invoice: json["invoice"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_name": userName,
    "created_at": createdAt?.toIso8601String(),
    "bank_name": bankName,
    "d_s_name": dSName,
    "payment_date": "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
    "invoice": invoice,
    "amount": amount,
  };
}
