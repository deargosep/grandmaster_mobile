import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/dio.dart';

class LearningsState extends ChangeNotifier {
  List<LearningType> _learnings = [
    // LearningType(
    //     id: 1, name: 'Теория на 10 гып', description: "Белый пояс", link: ""),
    // LearningType(
    //     id: 2,
    //     name: 'Теория на 9 гып',
    //     description: "Белый пояс с жёлтой полоской",
    //     link: ""),
    // LearningType(
    //     id: 3, name: 'Теория на 8 гып', description: "Жёлтый пояс", link: ""),
    // LearningType(
    //     id: 4,
    //     name: 'Теория на 7 гып',
    //     description: "Жёлтый пояс с зелёной полоской",
    //     link: ""),
    // LearningType(
    //     id: 5, name: 'Теория на 6 гып', description: "Зелёный пояс", link: ""),
    // LearningType(
    //     id: 6,
    //     name: 'Теория на 5 гып',
    //     description: "Зелёный пояс с синей полоской",
    //     link: ""),
    // LearningType(
    //     id: 7, name: 'Теория на 4 гып', description: "Синий пояс", link: ""),
    // LearningType(
    //     id: 8,
    //     name: 'Теория на 3 гып',
    //     description: "Синий пояс с красной полоской",
    //     link: ""),
    // LearningType(
    //     id: 9, name: 'Теория на 2 гып', description: "Красный пояс", link: ""),
    // LearningType(
    //     id: 10,
    //     name: 'Теория на 1 гып',
    //     description: "Красный пояс с чёрной полоской",
    //     link: ""),
    // LearningType(
    //     id: 11, name: 'Теория на 1 гып', description: "Чёрный пояс", link: ""),
  ];

  List<LearningType> get learnings => _learnings;

  Future<void> setLearnings({List<LearningType>? data}) async {
    var completer = new Completer();
    createDio().get('/instructions/').then((value) {
      List<LearningType> newList = [
        ...value.data.where((el) => !el["hidden"]).map((e) {
          // DateTime newDate = DateTime.parse(e["created_at"]);
          return LearningType(
              id: e["id"],
              name: e["title"],
              description: e["description"],
              order: e["order"],
              link: e["link"]);
        }).toList()
      ];
      _learnings = newList;
      notifyListeners();
      completer.complete();
    });
    return completer.future;
  }

  /// Removes all items from the cart.
  void removeAll() {
    _learnings.clear();
    notifyListeners();
  }
}

class LearningType {
  final id;
  final name;
  final description;
  final String link;
  final order;
  LearningType(
      {required this.id,
      required this.name,
      required this.description,
      this.order,
      required this.link});
}
