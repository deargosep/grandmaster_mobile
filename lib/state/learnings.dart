import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/dio.dart';

class LearningsState extends ChangeNotifier {
  List<LearningType> _learnings = [];
  List<LearningType> get learnings => _learnings;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> setLearnings({List<LearningType>? data}) async {
    _isLoaded = false;
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
    }).whenComplete(() {
      _isLoaded = true;
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
