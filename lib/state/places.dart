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
          print(e);
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
                            schedules: [
                              ...el["schedules"]
                                  .map((e) => TrainerSchedule(
                                      minAge: e["min_age"],
                                      maxAge: e["max_age"],
                                      items: e["items"]
                                          .map((et) => TScheduleTime(
                                              startTime: et["start_time"],
                                              finishTime: et["finish_time"],
                                              daysOfWeek: et["weekdays"]))
                                          .toList()))
                                  .toList()
                            ]))
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
  final List<TrainerSchedule>? schedules;
  Trainer({
    required this.id,
    required this.fio,
    this.photo,
    schedules,
  }) : schedules = schedules ?? [];
}

class TrainerSchedule {
  final int minAge;
  final int maxAge;
  final List<TScheduleTime> items;
  TrainerSchedule(
      {required this.minAge, required this.maxAge, required this.items});
}

class TScheduleTime {
  final String startTime;
  final String finishTime;
  final List<String> daysOfWeek;
  TScheduleTime(
      {required this.startTime,
      required this.finishTime,
      required this.daysOfWeek});
}
