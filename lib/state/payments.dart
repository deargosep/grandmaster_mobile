import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/dio.dart';

class PaymentsState extends ChangeNotifier {
  List<PaymentType> _payments = [];
  List<PaymentType> get payments => _payments;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> setPayments() async {
    var completer = new Completer();
    createDio().get('/invoices/current_bills/').then((value) {
      List<PaymentType> newList = [
        ...value.data.map((e) {
          // DateTime newDate = DateTime.parse(e["created_at"]);
          return PaymentType(
              id: e["id"],
              purpose: e["bill"]["purpose"],
              service: e["bill"]["service"],
              amount: e["bill"]["amount"],
              paid: e["is_paid"],
              blocked: e["is_blocked"],
              activated_at: DateTime.parse(e["bill"]["activated_at"]),
              must_be_paid_at: DateTime.parse(e["bill"]["must_be_paid_at"]),
              periodic: e["bill"]["is_periodic"],
              period: e["bill"]["period"]);
        }).toList()
      ];
      _payments = newList;
      notifyListeners();
      completer.complete();
    }).whenComplete(() {
      _isLoaded = true;
    });
    return completer.future;
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
  final String purpose;
  final String service;
  final DateTime activated_at;
  final DateTime must_be_paid_at;
  final int amount;
  final bool paid;
  final bool blocked;
  final bool periodic;
  final period;

  PaymentType(
      {required this.id,
      required this.purpose,
      required this.service,
      required this.activated_at,
      required this.must_be_paid_at,
      required this.amount,
      required this.periodic,
      required this.period,
      required this.paid,
      required this.blocked});
}
