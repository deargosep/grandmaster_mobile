import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsState extends ChangeNotifier {
  List<EventType> _events = [
    EventType(
        id: "123adssdad3",
        name: "Катаемся на барсуках",
        timeDateStart: DateTime(2022, 8, 5, 15),
        timeDateEnd: DateTime(2022, 8, 7),
        registerEnd: DateTime(2022, 8, 6, 15),
        address: 'Москва, Большая Дмитровка, д.9',
        description:
            "Приглашаем тебя покататься с нами по городу! Компания веселая! Обещаем, что будет весело, ждем тебя с нетерпением!!!",
        closed: false,
        members: ['Иванов Иван Иванович', 'Иванов Иван Иванович2']),
    EventType(
        id: "123adssdad",
        name: "Катаемся на барсуках2",
        timeDateStart: DateTime(2022, 8, 5, 15),
        timeDateEnd: DateTime(2022, 8, 11),
        registerEnd: DateTime(2022, 8, 10, 18),
        address: 'Москва, Большая Дмитровка, д.9',
        description:
            "Приглашаем тебя покататься с нами по городу! Компания веселая! Обещаем, что будет весело, ждем тебя с нетерпением!!!",
        closed: true,
        members: [])
  ];

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
