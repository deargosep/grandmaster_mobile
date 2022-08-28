import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grandmaster/utils/dio.dart';

class ScheduleState extends ChangeNotifier {
  ScheduleType _schedule = ScheduleType(
    days: {
      "monday": [],
      "tuesday": [],
      "wednesday": [],
      "thursday": [],
      "friday": [],
      "saturday": [],
      "sunday": [],
    },
  );

  ScheduleType get schedule => _schedule;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> setSchedule(placeId, groupId,
      {Function(DioError, ErrorInterceptorHandler)? errHandler,
      showSnackbar = true}) async {
    _isLoaded = false;
    var completer = new Completer();
    createDio(
            errHandler: (err, handler) {
              errHandler!(err, handler);
              completer.completeError(err);
            },
            showSnackbar: showSnackbar)
        .get('/schedule/?gym=${placeId}&sport_group=${groupId}')
        .catchError((err) {
      completer.completeError(err);
    }).then((value) {
      var e = value.data;
      _schedule = ScheduleType(
        days: {
          "monday": [...e["days"]["monday"]],
          "tuesday": [...e["days"]["tuesday"]],
          "wednesday": [...e["days"]["wednesday"]],
          "thursday": [...e["days"]["thursday"]],
          "friday": [...e["days"]["friday"]],
          "saturday": [...e["days"]["saturday"]],
          "sunday": [...e["days"]["sunday"]],
        },
        gym: e["gym"].toString(),
        group: e["sport_group"].toString(),
      );
      notifyListeners();
      completer.complete(_schedule);
    }).whenComplete(() {
      _isLoaded = true;
    });
    return completer.future;
  }

  // /// Removes all items from the cart.
  // void removeAll() {
  //   _schedule =
  //   notifyListeners();
  // }
}

class ScheduleType {
  final Map<String, List<String?>> days;
  final String? gym;
  final String? group;

  ScheduleType({
    required this.days,
    this.gym,
    this.group,
  });
}
