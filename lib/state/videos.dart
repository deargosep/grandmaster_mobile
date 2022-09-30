import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/dio.dart';

class VideosState extends ChangeNotifier {
  List<Video> _videos = [];

  List<Video> get videos => _videos;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> setVideos({List<Video>? data}) async {
    _isLoaded = false;
    var completer = new Completer();
    createDio().get('/videos/').then((value) {
      List<Video> newList = [
        ...value.data.where((el) => !el["hidden"]).map((e) {
          DateTime newDate = DateTime.parse(e["created_at"]);
          return Video(
              id: e["id"],
              name: e["title"],
              createdAt: newDate,
              link: e["link"],
              order: e["order"]);
        }).toList()
      ];
      _videos = newList;
      completer.complete();
      notifyListeners();
    }).whenComplete(() {
      _isLoaded = true;
    });
    ;
    return completer.future;
  }

  /// Removes all items from the cart.
  void removeAll() {
    _videos.clear();
    notifyListeners();
  }
}

class Video {
  final id;
  final name;
  final DateTime createdAt;
  final String link;
  final order;
  Video(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.link,
      this.order});
}
