import 'package:flutter/material.dart';
import 'package:grandmaster/state/events.dart';

class StoriesState extends ChangeNotifier {
  List<StoryType> _stories = [
    StoryType(
      id: '123',
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
      timedate: '01.01.2022',
      members: [
        {"username": "MajEstic21"},
        {"username": "Alice18"},
        {"username": "Pavkl"},
        {"username": "ForJik"}
      ],
      imageUrl:
          'https://www.miroworld.ru/wp-content/uploads/2017/08/Ozero-Bajkal.jpg',
    ),
    StoryType(
      id: '1232',
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
      timedate: '01.01.2022',
      members: [
        {"username": "MajEstic21"},
        {"username": "Alice18"},
        {"username": "Pavkl"},
        {"username": "ForJik"}
      ],
      imageUrl:
          'https://geographyofrussia.com/wp-content/uploads/2014/09/gandex.ru-26_5555_lesnoe-ozero-640x360.webp',
    ),
  ];

  List<StoryType> get stories => _stories;

  void setStories(List<StoryType> stories) {
    _stories = stories;
  }

  /// Removes all items from the cart.
  void removeAll() {
    _stories.clear();
    notifyListeners();
  }
}

class StoryType {
  final id;
  final Author author;
  final String imageUrl;
  final timedate;
  final List members;

  StoryType({
    required this.id,
    required this.author,
    required this.imageUrl,
    required this.timedate,
    required this.members,
  });
}
