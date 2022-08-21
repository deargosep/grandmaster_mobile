import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/dio.dart';

class PaymentsState extends ChangeNotifier {
  List<PaymentType> _payments = [
  ];

  List<PaymentType> get payments => _payments;

  void setPayments() {
    createDio().get('/invoices/current_bills/').then((value)  {
      print(value.data);
    });
    // _payments = ;
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
