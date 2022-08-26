import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/dio.dart';

class PlacesState extends ChangeNotifier {
  List<PlaceType> _places = [];
  List<Trainer> _trainers = [];

  List<PlaceType> get places => _places;
  List<Trainer> get trainers => _trainers;

  Future<void> setPlaces({List<PlaceType>? data}) async {
    var completer = new Completer();
    createDio().get('/gyms/').then((value) {
      List<PlaceType> newList = [
        ...value.data.where((el) => !el["hidden"]).map((e) {
          // DateTime newDate = DateTime.parse(e["created_at"]);
          return PlaceType(
              id: e["id"].toString(),
              name: e["title"],
              description: e["description"],
              cover: e["cover"],
              address: e["address"],
              trainers: [
                ...e["trainers"]
                    .map((el) => Trainer(
                        id: el["id"].toString(),
                        photo: el["photo"],
                        fio: el["full_name"],
                        category: 'Возрастная группа 7-14 лет',
                        daysOfWeek: 'Вт, Чт, Сб',
                        time: '09:00 - 10:30'))
                    .toList()
              ],
              order: e["order"] ?? e["number"]);
        }).toList()
      ];
      _places = newList;
      notifyListeners();
      completer.complete();
    });
    return completer.future;
  }

  PlaceType? getPlaces(id) {
    return _places.firstWhereOrNull((element) => element.id == id);
  }

  Future<void> setTrainers() async {
    var completer = new Completer();
    createDio().get('/sport_groups/trainers/').then((value) {
      List<Trainer> newList = [
        ...value.data.map((e) {
          // DateTime newDate = DateTime.parse(e["created_at"]);
          return Trainer(
            id: e["id"].toString(),
            fio: e["full_name"],
          );
        }).toList()
      ];
      _trainers = newList;
      notifyListeners();
      completer.complete();
    });
    return completer.future;
    // _trainers = events;
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
  final String? cover;
  final String address;
  final String description;
  final List<Trainer> trainers;
  final int? order;
  PlaceType(
      {required this.id,
      required this.name,
      this.cover,
      required this.address,
      required this.description,
      required this.trainers,
      this.order});
}

class Trainer {
  final String id;
  final String fio;
  final String? photo;
  final String? category;
  final String? daysOfWeek;
  final String? time;
  Trainer(
      {required this.id,
      required this.fio,
      this.photo,
      this.category,
      this.daysOfWeek,
      this.time});
}
