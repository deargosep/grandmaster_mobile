import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentsState extends ChangeNotifier {
  List<PaymentType> _payments = [
    PaymentType(
        id: "1",
        name: "Сборы",
        paymentEnd: DateTime(2022, 08, 22),
        price: 500.00,
        paid: false),
    PaymentType(
        id: "2",
        name: "Соревнования",
        paymentEnd: DateTime(2022, 06, 22),
        price: 1500.00,
        paid: false),
    PaymentType(
        id: "3",
        name: "Сборы",
        paymentEnd: DateTime(2022, 08, 22),
        price: 500.00,
        paid: true),
    PaymentType(
        id: "4",
        name: "Соревнования",
        paymentEnd: DateTime(2022, 06, 22),
        price: 1500.00,
        paid: true),
  ];

  List<PaymentType> get payments => _payments;

  void setPayments(List<PaymentType> events) {
    _payments = events;
  }

  PaymentType? getPayments(id) {
    return _payments.firstWhereOrNull((element) => element.id == id);
  }

  /// Removes all items from the cart.
  void removeAll() {
    _payments.clear();
    notifyListeners();
  }
}

class PaymentType {
  final id;
  final name;
  final DateTime paymentEnd;
  final double price;
  final bool paid;

  PaymentType(
      {required this.id,
      required this.name,
      required this.paymentEnd,
      required this.price,
      required this.paid});
}
