// To parse this JSON data, do
//
//     final createOrderModel = createOrderModelFromJson(jsonString);

import 'dart:convert';

CreateOrderModel createOrderModelFromJson(String str) => CreateOrderModel.fromJson(json.decode(str));

String createOrderModelToJson(CreateOrderModel data) => json.encode(data.toJson());

class CreateOrderModel {
    bool? status;
    Order? order;

    CreateOrderModel({
        this.status,
        this.order,
    });

    factory CreateOrderModel.fromJson(Map<String, dynamic> json) => CreateOrderModel(
        status: json["status"],
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "order": order?.toJson(),
    };
}

class Order {
    int? id;
    String? orderId;
    dynamic amount;
    String? currency;
    String? status;

    Order({
        this.id,
        this.orderId,
        this.amount,
        this.currency,
        this.status,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        orderId: json["orderId"],
        amount: json["amount"],
        currency: json["currency"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "amount": amount,
        "currency": currency,
        "status": status,
    };
}
