import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grandmaster/utils/dio.dart';

class VisitLogState extends ChangeNotifier {
  VisitLogType _visitLog = VisitLogType(
      id: 0,
      attending: [],
      start_time: "0:00",
      finish_time: "0:00",
      datetime: DateTime.now());

  VisitLogType get visitLog => _visitLog;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> setVisitLog(
    placeId,
    groupId,
  ) async {
    _isLoaded = false;
    var completer = new Completer();
    createDio(errHandler: (err, handler) {
      completer.completeError(err);
    }).get('/visit_log/?gym=${placeId}&sport_group=${groupId}').then((value) {
      var e = value.data;
      print(e);
      _visitLog = VisitLogType(
          id: e["schedule"]["id"],
          weekday: e["schedule"]["weekday"],
          start_time: e["schedule"]["start_time"],
          finish_time: e["schedule"]["finish_time"],
          gym: e["schedule"]["gym"],
          group: e["schedule"]["sport_group"],
          attending: e["attending"],
          datetime: DateTime.now());
      notifyListeners();
      completer.complete();
    }).whenComplete(() {
      _isLoaded = true;
    });
    ;
    return completer.future;
  }

  // /// Removes all items from the cart.
  // void removeAll() {
  //   _schedule =
  //   notifyListeners();
  // }
}

class VisitLogType {
  final int id;
  final List attending;
  final String? weekday;
  final String start_time;
  final String finish_time;
  final int? gym;
  final int? group;
  final DateTime datetime;

  VisitLogType(
      {required this.id,
      required this.attending,
      this.weekday,
      required this.start_time,
      required this.finish_time,
      this.gym,
      this.group,
      required this.datetime});
}
