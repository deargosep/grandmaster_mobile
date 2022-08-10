import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Places extends ChangeNotifier {
  List<PlaceType> _places = [
    PlaceType(
        id: "123adssdad3",
        name: "Зал №1",
        description:
            "Приглашаем тебя покататься с нами по городу! Компания веселая! Обещаем, что будет весело, ждем тебя с нетерпением!!!",
        address: 'Москва, Большая Дмитровка, д.9',
        trainers: [
          Trainer(
              id: '121',
              fio: "Глухарев Глухарь Глухарьевич",
              category: "Возрастная группа 7-14 лет",
              daysOfWeek: "Вт, Чт, Сб",
              time: "09:00 - 10:30"),
          Trainer(
              id: '123',
              fio: "Иванов Иван Иванович",
              category: "Возрастная группа 7-14 лет",
              daysOfWeek: "Вт, Чт, Сб",
              time: "09:00 - 10:30"),
        ]),
    PlaceType(
        id: "123adssdad",
        name: "Зал №2",
        description:
            "Приглашаем тебя покататься с нами по городу! Компания веселая! Обещаем, что будет весело, ждем тебя с нетерпением!!!",
        address: 'Москва, Большая Дмитровка, д.9',
        trainers: [
          Trainer(
              id: '121',
              fio: "Глухарев Глухарь Глухарьевич",
              category: "Возрастная группа 7-14 лет",
              daysOfWeek: "Вт, Чт, Сб",
              time: "09:00 - 10:30"),
          Trainer(
              id: '123',
              fio: "Иванов Иван Иванович",
              category: "Возрастная группа 7-14 лет",
              daysOfWeek: "Вт, Чт, Сб",
              time: "09:00 - 10:30"),
        ])
  ];
  List<Trainer> _trainers = [
    Trainer(
        id: '121',
        fio: "Глухарев Глухарь Глухарьевич",
        category: "Возрастная группа 7-14 лет",
        daysOfWeek: "Вт, Чт, Сб",
        time: "09:00 - 10:30"),
    Trainer(
        id: '123',
        fio: "Иванов Иван Иванович",
        category: "Возрастная группа 7-14 лет",
        daysOfWeek: "Вт, Чт, Сб",
        time: "09:00 - 10:30"),
    Trainer(
        id: '124',
        fio: "Глухарев Глухарь Глухарьевич222",
        category: "Возрастная группа 7-14 лет",
        daysOfWeek: "Вт, Чт, Сб",
        time: "09:00 - 10:30")
  ];

  List<PlaceType> get places => _places;
  List<Trainer> get trainers => _trainers;

  void setPlaces(List<PlaceType> events) {
    _places = events;
  }

  PlaceType? getPlaces(id) {
    return _places.firstWhereOrNull((element) => element.id == id);
  }

  void setTrainers(List<Trainer> events) {
    _trainers = events;
  }

  Trainer? getTrainers(id) {
    return _trainers.firstWhereOrNull((element) => element.id == id);
  }

  /// Removes all items from the cart.
  void removeAll() {
    _places.clear();
    notifyListeners();
  }
}

class PlaceType {
  final String id;
  final String name;
  final String address;
  final String description;
  final List<Trainer>? trainers;
  PlaceType(
      {required this.id,
      required this.name,
      required this.address,
      required this.description,
      this.trainers});
}

class Trainer {
  final String id;
  final String fio;
  final String category;
  final String daysOfWeek;
  final String time;
  Trainer(
      {required this.id,
      required this.fio,
      required this.category,
      required this.daysOfWeek,
      required this.time});
}
