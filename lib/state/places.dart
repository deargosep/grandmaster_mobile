import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/dio.dart';

class PlacesState extends ChangeNotifier {
  List<PlaceType> _places = [];
  List<Trainer> _trainers = [];

  List<PlaceType> get places => _places;
  List<Trainer> get trainers => _trainers;

  void setPlaces({List<PlaceType>? data}) {
    if (data != null)
      _places = data;
    else {
      createDio().get('/gyms/').then((value) {
        print(value.data);
        List<PlaceType> newList = [
          ...value.data.where((el) => !el["hidden"]).map((e) {
            // DateTime newDate = DateTime.parse(e["created_at"]);
            return PlaceType(
                id: e["id"],
                name: e["name"],
                description: e["description"],
                address: e["address"],
                order: e["order"] ?? e["number"]);
          }).toList()
        ];
        _places = newList;
        notifyListeners();
      });
    }
    notifyListeners();
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
  final String? cover;
  final String address;
  final String description;
  final List<Trainer>? trainers;
  final int? order;
  PlaceType(
      {required this.id,
      required this.name,
      this.cover,
      required this.address,
      required this.description,
      this.trainers,
      this.order});
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
