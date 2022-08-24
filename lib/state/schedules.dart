import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grandmaster/utils/dio.dart';

class ScheduleState extends ChangeNotifier {
  ScheduleType _schedule = ScheduleType();

  ScheduleType get schedule => _schedule;

  Future<void> setSchedule(
    placeId,
    groupId,
  ) async {
    var completer = new Completer();
    createDio()
        .get('/schedule/?gym=${placeId}&sport_group=${groupId}')
        .then((value) {
      var e = value.data;
      print(e);
      _schedule = ScheduleType(
        id: e["id"],
      );
      notifyListeners();
      completer.complete();
    });
  }

  // /// Removes all items from the cart.
  // void removeAll() {
  //   _schedule =
  //   notifyListeners();
  // }
}

class ScheduleType {
  final id;
  final String? purpose;
  final String? service;
  final DateTime? activated_at;
  final DateTime? must_be_paid_at;
  final int? amount;
  final bool? paid;
  final bool? blocked;
  final bool? periodic;
  final period;

  ScheduleType(
      {this.id,
      this.purpose,
      this.service,
      this.activated_at,
      this.must_be_paid_at,
      this.amount,
      this.periodic,
      this.period,
      this.paid,
      this.blocked});
}
