import 'dart:convert';

List<BankListModel> bankListModelFromJson(String str) =>
    List<BankListModel>.from(json.decode(str).map((x) => BankListModel.fromJson(x)));

String bankListModelToJson(List<BankListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BankListModel {
  final int? id;
  final String? bankName;

  BankListModel({
    this.id,
    this.bankName,
  });

  factory BankListModel.fromJson(Map<String, dynamic> json) => BankListModel(
    id: json["id"],
    bankName: json["bank_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bank_name": bankName,
  };
}