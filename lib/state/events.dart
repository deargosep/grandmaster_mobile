import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsState extends ChangeNotifier {
  List<EventType> _events = [];

  List<EventType> get events => _events;

  void setEvents(List<EventType> events) {
    _events = events;
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
  final DateTime registerEnd;
  final bool closed;
  final description;
  final address;
  final List members;

  EventType(
      {required this.id,
      required this.name,
      required this.timeDateStart,
      required this.timeDateEnd,
      required this.registerEnd,
      this.closed = false,
      required this.description,
      required this.address,
      members})
      : members = members ?? [];
}
