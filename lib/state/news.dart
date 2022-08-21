import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/dio.dart';

class Articles extends ChangeNotifier {
  List<ArticleType> _news = [];

  List<ArticleType> get news => _news;

  void setNews({List<ArticleType>? data}) {
    if (data != null)
      _news = data;
    else {
      createDio().get('/news/').then((value) {
        List<ArticleType> newList = [
          ...value.data["results"].where((el) => !el["hidden"]).map((e) {
            DateTime newDate = DateTime.parse(e["created_at"]);
            return ArticleType(
                id: e["id"],
                name: e["title"],
                dateTime: newDate,
                description: e["description"],
                views: e["viewed_times"],
                cover: e["cover"],
                photos: e["images"],
                order: e["order"]);
          }).toList()
        ];
        print(newList);
        _news = newList;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  ArticleType? getNews(id) {
    return _news.firstWhereOrNull((element) => element.id == id);
  }

  /// Removes all items from the cart.
  void removeAll() {
    _news.clear();
    notifyListeners();
  }
}

class ArticleType {
  final id;
  final name;
  final cover;
  final DateTime dateTime;
  final List photos;
  final description;
  final views;
  final order;

  ArticleType(
      {required this.id,
      required this.name,
      this.cover,
      required this.dateTime,
      required this.description,
      required this.views,
      photos,
      this.order})
      : photos = photos ?? [];
}
