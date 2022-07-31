import 'package:flutter/material.dart';

class Articles extends ChangeNotifier {
  List<ArticleType> _events = [
    ArticleType(
        id: "123adssdad",
        author: Author(
          id: "12222",
          username: "HotLine",
          name: "Игорь",
          age: 24,
          country: "Россия",
          city: "Москва",
          description:
              "С другой стороны, экономическая повестка сегодняшнего дня предоставляет широкие возможности для существующих финансовых и административных условий.",
        ),
        name: "Катаемся на барсуках",
        date: "09 июня 2022",
        time: '15:00',
        description:
            "Приглашаем тебя покататься с нами по городу! Компания веселая! Обещаем, что будет весело, ждем тебя с нетерпением!!!",
        views: 100),
    ArticleType(
        id: "123adssdad",
        author: Author(
          id: "12222",
          username: "fdfdfdfdfdfdfd",
          name: "Игорь",
          age: 24,
          country: "Россия",
          city: "Москва",
          description:
              "С другой стороны, экономическая повестка сегодняшнего дня предоставляет широкие возможности для существующих финансовых и административных условий.",
        ),
        name: "Катаемся на барсуках2",
        date: "09 июня 2022",
        time: '15:00',
        description:
            "Приглашаем тебя покататься с нами по городу! Компания веселая! Обещаем, что будет весело, ждем тебя с нетерпением!!!",
        views: 100)
  ];

  List<ArticleType> get events => _events;

  void setEvents(List<ArticleType> events) {
    _events = events;
  }

  /// Removes all items from the cart.
  void removeAll() {
    _events.clear();
    notifyListeners();
  }
}

class ArticleType {
  final id;
  final Author author;
  final name;
  final date;
  final time;
  final description;
  final views;

  ArticleType({
    required this.id,
    required this.author,
    required this.name,
    required this.date,
    required this.time,
    required this.description,
    required this.views,
  });
}

class Author {
  final id;
  final username;
  final role;
  final gender;
  final birthday;
  final age;
  final country;
  final city;
  final name;
  final description;
  final registration_date;

  Author({
    required this.id,
    required this.username,
    this.role,
    this.gender,
    this.birthday,
    required this.name,
    required this.age,
    required this.country,
    required this.city,
    required this.description,
    this.registration_date,
  });
}
