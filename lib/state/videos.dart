import 'package:flutter/material.dart';

import '../utils/dio.dart';

class VideosState extends ChangeNotifier {
  List<Video> _videos = [];

  List<Video> get videos => _videos;

  void setVideos({List<Video>? data}) {
    if (data != null)
      _videos = data;
    else {
      createDio().get('/videos/').then((value) {
        List<Video> newList = [
          ...value.data.where((el) => !el["hidden"]).map((e) {
            DateTime newDate = DateTime.parse(e["created_at"]);
            return Video(
                id: e["id"],
                name: e["title"],
                createdAt: newDate,
                link: e["link"]);
          }).toList()
        ];
        print(newList);
        _videos = newList;
        notifyListeners();
      });
    }
    notifyListeners();
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
  Video(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.link});
}
