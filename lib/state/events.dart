import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';

import '../utils/dio.dart';

class EventsState extends ChangeNotifier {
  List<EventType> _events = [];

  List<EventType> get events => _events;

  Future setEvents({List<EventType>? data}) {
    var completer = new Completer();
    createDio().get('/events/').then((value) {
      List<EventType> newList = [
        ...value.data
            .where((el) => el["hidden"] == null || !el["hidden"])
            .map((e) {
          log(e.toString());
          // DateTime newDate = DateTime.parse(e["created_at"]);
          return EventType(
              id: e["id"],
              name: e["name"],
              description: e["description"],
              address: e["address"],
              timeDateStart: DateTime.parse(e["start_date"]),
              timeDateEnd: DateTime.parse(e["end_date"]),
              cover: e["cover"],
              open: e["open"],
              order: e["number"],
              members: <MinimalUser>[...e["members"]]);
        }).toList()
      ];
      _events = newList;
      notifyListeners();
      completer.complete();
    });
    return completer.future;
  }

  EventType? getEvents(id) {
    return _events.firstWhereOrNull((element) => element.id == id);
  }

  /// Removes all items from the cart.
  void removeAll() {
    _events.clear();
    notifyListeners();
  }
}

class EventType {
  final id;
  final name;
  final DateTime timeDateStart;
  final DateTime timeDateEnd;
  final description;
  final address;
  final List<MinimalUser> members;
  final String cover;
  final order;
  final bool open;
  EventType(
      {required this.id,
      required this.name,
      required this.timeDateStart,
      required this.timeDateEnd,
      required this.description,
      required this.address,
      required this.cover,
      required this.order,
      required this.open,
      members})
      : members = members ?? [];
}
