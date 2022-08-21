import 'package:flutter/material.dart';

import '../utils/dio.dart';

class LearningsState extends ChangeNotifier {
  List<LearningType> _learnings = [];

  List<LearningType> get learnings => _learnings;

  void setLearnings({List<LearningType>? data}) {
    if (data != null)
      _learnings = data;
    else {
      createDio().get('/instructions/').then((value) {
        List<LearningType> newList = [
          ...value.data.where((el) => !el["hidden"]).map((e) {
            print(e);
            // DateTime newDate = DateTime.parse(e["created_at"]);
            return LearningType(
                id: e["id"],
                name: e["title"],
                description: e["description"],
                order: e["order"],
                link: e["link"]);
          }).toList()
        ];
        print(newList);
        _learnings = newList;
        notifyListeners();
      });
    }
    notifyListeners();
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
