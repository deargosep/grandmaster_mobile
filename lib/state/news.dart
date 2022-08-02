import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Articles extends ChangeNotifier {
  List<ArticleType> _news = [
    ArticleType(
        id: "123adssdad3",
        name: "Катаемся на барсуках",
        date: "09 июня 2022",
        time: '15:00',
        description:
            "Приглашаем тебя покататься с нами по городу! Компания веселая! Обещаем, что будет весело, ждем тебя с нетерпением!!!",
        views: 100),
    ArticleType(
        id: "123adssdad",
        name: "Катаемся на барсуках2",
        date: "09 июня 2022",
        time: '15:00',
        description:
            "Приглашаем тебя покататься с нами по городу! Компания веселая! Обещаем, что будет весело, ждем тебя с нетерпением!!!",
        views: 100)
  ];

  List<ArticleType> get news => _news;

  void setEvents(List<ArticleType> events) {
    _news = events;
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
  final date;
  final time;
  final description;
  final views;

  ArticleType({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.description,
    required this.views,
  });
}

class User {
  final id;
  final fullName;
  final phoneNumber;
  final role;
  final gender;
  final birthday;
  final age;
  final country;
  final city;
  final name;
  final registration_date;
  final List<User> children;

  User({
    required this.id,
    required this.fullName,
    this.phoneNumber,
    children,
    this.role,
    this.gender,
    this.birthday,
    this.name,
    required this.age,
    required this.country,
    required this.city,
    this.registration_date,
  }) : children = children ?? [];
}
