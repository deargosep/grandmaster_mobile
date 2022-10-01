import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';

import '../utils/dio.dart';

class EventsState extends ChangeNotifier {
  List<EventType> _events = [];
  List<EventType> get events => _events;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future setEvents({List<EventType>? data}) {
    _isLoaded = false;
    var completer = new Completer();
    createDio().get('/events/').then((value) {
      List<EventType> newList = [
        ...value.data
            .where((el) => el["hidden"] == null || !el["hidden"])
            .map((e) {
          log(e.toString());
          DateTime deadlineDate = DateTime.parse(e["deadline_date"]);
          List<MinimalUser> members = [
            ...e["members"]
                .map((e) => MinimalUser(
                    fullName: e["full_name"],
                    id: e["id"],
                    marked: e["marked"],
                    isAdmitted: e["is_admitted"]))
                .toList()
          ];
          members.sort((a, b) {
            return a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
          });
          return EventType(
              id: e["id"],
              name: e["name"],
              description: e["description"],
              address: e["address"],
              timeDateStart: DateTime.parse(e["start_date"]),
              timeDateEnd: DateTime.parse(e["end_date"]),
              cover: e["cover"],
              open: e["open"],
              ended: e["ended"],
              order: e["order"],
              timeDateDeadline: DateTime.parse(e["deadline_date"]),
              isAfter: DateTime.now().isAfter(deadlineDate),
              members: members);
        }).toList()
      ];
      _events = newList;
      notifyListeners();
      completer.complete();
    }).whenComplete(() {
      _isLoaded = true;
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
  final DateTime timeDateDeadline;
  final description;
  final address;
  final List<MinimalUser> members;
  final String? cover;
  final order;
  final bool open;
  final bool ended;
  final bool isAfter;
  EventType(
      {required this.id,
      required this.name,
      required this.timeDateStart,
      required this.timeDateEnd,
      required this.timeDateDeadline,
      required this.description,
      required this.address,
      required this.cover,
      required this.order,
      required this.ended,
      required this.open,
      this.isAfter = false,
      members})
      : members = members ?? [];
}
