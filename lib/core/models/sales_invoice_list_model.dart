import 'dart:convert';

SalesInvoiceListModel salesInvoiceListModelFromJson(String str) => SalesInvoiceListModel.fromJson(json.decode(str));

String salesInvoiceListModelToJson(SalesInvoiceListModel data) => json.encode(data.toJson());

class SalesInvoiceListModel {
  final Company? company;
  final Invoice? invoice;
  final Dealer? dealer;
  final Financial? financial;
  final List<Item>? items;

  SalesInvoiceListModel({
    this.company,
    this.invoice,
    this.dealer,
    this.financial,
    this.items,
  });

  factory SalesInvoiceListModel.fromJson(Map<String, dynamic> json) => SalesInvoiceListModel(
    company: json["company"] == null ? null : Company.fromJson(json["company"]),
    invoice: json["invoice"] == null ? null : Invoice.fromJson(json["invoice"]),
    dealer: json["dealer"] == null ? null : Dealer.fromJson(json["dealer"]),
    financial: json["financial"] == null ? null : Financial.fromJson(json["financial"]),
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "company": company?.toJson(),
    "invoice": invoice?.toJson(),
    "dealer": dealer?.toJson(),
    "financial": financial?.toJson(),
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Company {
  final String? name;
  final String? address;
  final String? phone;
  final String? email;

  Company({
    this.name,
    this.address,
    this.phone,
    this.email,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    name: json["name"] is String ? json["name"] : (json["name"]?.toString() ?? null),
    address: json["address"] is String ? json["address"] : (json["address"]?.toString() ?? null),
    phone: json["phone"] is String ? json["phone"] : (json["phone"]?.toString() ?? null),
    email: json["email"] is String ? json["email"] : (json["email"]?.toString() ?? null),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "phone": phone,
    "email": email,
  };
}

class Dealer {
  final String? name;
  final String? code;
  final String? type;
  final String? address;
  final String? warehouse;
  final String? territory;
  final String? employee;
  final int? dealerCreditDuration;

  Dealer({
    this.name,
    this.code,
    this.type,
    this.address,
    this.warehouse,
    this.territory,
    this.employee,
    this.dealerCreditDuration
  });

  factory Dealer.fromJson(Map<String, dynamic> json) => Dealer(
    name: json["name"] is String ? json["name"] : (json["name"]?.toString() ?? null),
    code: json["code"] is String ? json["code"] : (json["code"]?.toString() ?? null),
    type: json["type"] is String ? json["type"] : (json["type"]?.toString() ?? null),
    address: json["address"] is String ? json["address"] : (json["address"]?.toString() ?? null),
    warehouse: json["warehouse"] is String ? json["warehouse"] : (json["warehouse"]?.toString() ?? null),
    territory: json["territory"] is String ? json["territory"] : (json["territory"]?.toString() ?? null),
    employee: json["employee"] is String ? json["employee"] : (json["employee"]?.toString() ?? null),
    dealerCreditDuration: json["dealer_credit_duration"] is int ? json["dealer_credit_duration"] : (json["dealer_credit_duration"] is String ? int.tryParse(json["dealer_credit_duration"]) : json["dealer_credit_duration"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "type": type,
    "address": address,
    "warehouse": warehouse,
    "territory": territory,
    "employee": employee,
    "dealer_credit_duration": dealerCreditDuration,
  };
}

class Financial {
  final String? openingBalance;
  final String? currentInvoiceValue;
  final String? currentBalance;
  final dynamic lastPayment;
  final String? totalValue;
  final String? commission;
  final String? payable;
  final String? payableInWords;

  Financial({
    this.openingBalance,
    this.currentInvoiceValue,
    this.currentBalance,
    this.lastPayment,
    this.totalValue,
    this.commission,
    this.payable,
    this.payableInWords,
  });

  factory Financial.fromJson(Map<String, dynamic> json) => Financial(
    openingBalance: json["opening_balance"] is String ? json["opening_balance"] : (json["opening_balance"]?.toString() ?? null),
    currentInvoiceValue: json["current_invoice_value"] is String ? json["current_invoice_value"] : (json["current_invoice_value"]?.toString() ?? null),
    currentBalance: json["current_balance"] is String ? json["current_balance"] : (json["current_balance"]?.toString() ?? null),
    lastPayment: json["last_payment"],
    totalValue: json["total_value"] is String ? json["total_value"] : (json["total_value"]?.toString() ?? null),
    commission: json["commission"] is String ? json["commission"] : (json["commission"]?.toString() ?? null),
    payable: json["payable"] is String ? json["payable"] : (json["payable"]?.toString() ?? null),
    payableInWords: json["payable_in_words"] is String ? json["payable_in_words"] : (json["payable_in_words"]?.toString() ?? null),
  );

  Map<String, dynamic> toJson() => {
    "opening_balance": openingBalance,
    "current_invoice_value": currentInvoiceValue,
    "current_balance": currentBalance,
    "last_payment": lastPayment,
    "total_value": totalValue,
    "commission": commission,
    "payable": payable,
    "payable_in_words": payableInWords,
  };
}

class Invoice {
  final String? invoiceNo;
  final String? invoiceDate;
  final String? itemType;
  final dynamic transportCost;
  final String? narration;
  final String? createdBy;
  final String? currentTime;
  final String? currentDate;

  Invoice({
    this.invoiceNo,
    this.invoiceDate,
    this.itemType,
    this.transportCost,
    this.narration,
    this.createdBy,
    this.currentTime,
    this.currentDate,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    invoiceNo: json["invoice_no"] is String ? json["invoice_no"] : (json["invoice_no"]?.toString() ?? null),
    invoiceDate: json["invoice_date"] is String ? json["invoice_date"] : (json["invoice_date"]?.toString() ?? null),
    itemType: json["item_type"] is String ? json["item_type"] : (json["item_type"]?.toString() ?? null),
    transportCost: json["transport_cost"],
    narration: json["narration"] is String ? json["narration"] : (json["narration"]?.toString() ?? null),
    createdBy: json["created_by"] is String ? json["created_by"] : (json["created_by"]?.toString() ?? null),
    currentTime: json["current_time"] is String ? json["current_time"] : (json["current_time"]?.toString() ?? null),
    currentDate: json["current_date"] is String ? json["current_date"] : (json["current_date"]?.toString() ?? null),
  );

  Map<String, dynamic> toJson() => {
    "invoice_no": invoiceNo,
    "invoice_date": invoiceDate,
    "item_type": itemType,
    "transport_cost": transportCost,
    "narration": narration,
    "created_by": createdBy,
    "current_time": currentTime,
    "current_date": currentDate,
  };
}

class Item {
  final int? id;
  final String? productName;
  final String? unitPrice;
  final String? qty;
  final int? weight;
  final String? weightUnit;
  final String? unitName;
  final int? bonus;
  final int? discountPercentage;
  final String? discountAmount;
  final String? totalPrice;

  Item({
    this.id,
    this.productName,
    this.unitPrice,
    this.qty,
    this.weight,
    this.weightUnit,
    this.unitName,
    this.bonus,
    this.discountPercentage,
    this.discountAmount,
    this.totalPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"] is int ? json["id"] : (json["id"] is String ? int.tryParse(json["id"]) : json["id"]),
    productName: json["product_name"] is String ? json["product_name"] : (json["product_name"]?.toString() ?? null),
    unitPrice: json["unit_price"] is String ? json["unit_price"] : (json["unit_price"]?.toString() ?? null),
    qty: json["qty"] is String ? json["qty"] : (json["qty"]?.toString() ?? null),
    weight: json["weight"] is int ? json["weight"] : (json["weight"] is String ? int.tryParse(json["weight"]) : json["weight"]),
    weightUnit: json["weight_unit"] is String ? json["weight_unit"] : (json["weight_unit"]?.toString() ?? null),
    unitName: json["unit_name"] is String ? json["unit_name"] : (json["unit_name"]?.toString() ?? null),
    bonus: json["bonus"] is int ? json["bonus"] : (json["bonus"] is String ? int.tryParse(json["bonus"]) : json["bonus"]),
    discountPercentage: json["discount_percentage"] is int ? json["discount_percentage"] : (json["discount_percentage"] is String ? int.tryParse(json["discount_percentage"]) : json["discount_percentage"]),
    discountAmount: json["discount_amount"] is String ? json["discount_amount"] : (json["discount_amount"]?.toString() ?? null),
    totalPrice: json["total_price"] is String ? json["total_price"] : (json["total_price"]?.toString() ?? null),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "unit_price": unitPrice,
    "qty": qty,
    "weight": weight,
    "weight_unit": weightUnit,
    "unit_name": unitName,
    "bonus": bonus,
    "discount_percentage": discountPercentage,
    "discount_amount": discountAmount,
    "total_price": totalPrice,
  };
}


