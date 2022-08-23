import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/dio.dart';

class EventsState extends ChangeNotifier {
  List<EventType> _events = [];

  List<EventType> get events => _events;

  void setEvents({List<EventType>? data}) {
    if (data != null)
      _events = data;
    else {
      createDio().get('/events/').then((value) {
        print(value);
        List<EventType> newList = [
          ...value.data["results"]
              .where((el) => el["hidden"] == null || !el["hidden"])
              .map((e) {
            // DateTime newDate = DateTime.parse(e["created_at"]);
            return EventType(
                id: e["id"],
                name: e["name"],
                description: e["description"],
                address: e["address"],
                timeDateStart: DateTime.parse(e["start_date"]),
                timeDateEnd: DateTime.parse(e["end_date"]),
                cover: e["cover"]);
          }).toList()
        ];
        print(newList);
        _events = newList;
        notifyListeners();
      });
    }
    notifyListeners();
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
  final List members;
  final String cover;
  EventType(
      {required this.id,
      required this.name,
      required this.timeDateStart,
      required this.timeDateEnd,
      required this.description,
      required this.address,
      required this.cover,
      members})
      : members = members ?? [];
}
