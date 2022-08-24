import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/dio.dart';

class AboutState extends ChangeNotifier {
  List<AboutType> _about = [];

  List<AboutType> get about => _about;

  Future<void> setAbout({List<AboutType>? data}) async {
    var completer = new Completer();
    createDio().get('/club_content/').then((value) {
      List<AboutType> newList = [
        ...value.data.where((el) => !el["hidden"]).map((e) {
          print(e);
          // DateTime newDate = DateTime.parse(e["created_at"]);
          return AboutType(
              id: e["id"],
              name: e["name"],
              description: e["description"],
              order: e["number"],
              cover: e["cover"]);
        }).toList()
      ];
      _about = newList;
      notifyListeners();
      completer.complete();
    });
  }

  // AboutType? getNews(id) {
  //   return _about.firstWhereOrNull((element) => element.id == id);
  // }

  /// Removes all items from the cart.
  void removeAll() {
    _about.clear();
    notifyListeners();
  }
}

class AboutType {
  final id;
  final name;
  final cover;
  final description;
  final int? order;

  AboutType(
      {required this.id,
      required this.name,
      this.cover,
      required this.description,
      this.order});
}
