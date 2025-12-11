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
    name: json["name"],
    address: json["address"],
    phone: json["phone"],
    email: json["email"],
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
    name: json["name"],
    code: json["code"],
    type: json["type"],
    address: json["address"],
    warehouse: json["warehouse"],
    territory: json["territory"],
    employee: json["employee"],
    dealerCreditDuration: json["dealer_credit_duration"],
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
    openingBalance: json["opening_balance"],
    currentInvoiceValue: json["current_invoice_value"],
    currentBalance: json["current_balance"],
    lastPayment: json["last_payment"],
    totalValue: json["total_value"],
    commission: json["commission"],
    payable: json["payable"],
    payableInWords: json["payable_in_words"],
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
    invoiceNo: json["invoice_no"],
    invoiceDate: json["invoice_date"],
    itemType: json["item_type"],
    transportCost: json["transport_cost"],
    narration: json["narration"],
    createdBy: json["created_by"],
    currentTime: json["current_time"],
    currentDate: json["current_date"],
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
    id: json["id"],
    productName: json["product_name"],
    unitPrice: json["unit_price"],
    qty: json["qty"],
    weight: json["weight"],
    weightUnit: json["weight_unit"],
    unitName: json["unit_name"],
    bonus: json["bonus"],
    discountPercentage: json["discount_percentage"],
    discountAmount: json["discount_amount"],
    totalPrice: json["total_price"],
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


