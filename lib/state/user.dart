import 'package:flutter/material.dart';
import 'package:grandmaster/state/events.dart';

class User extends ChangeNotifier {
  UserType _user = UserType();
  Author _userMeta = Author(
    id: "12222",
    role: "moderator",
    username: "HotLine",
    name: "Игорь",
    birthday: '03.06.2000',
    gender: 'Мужчина',
    age: 24,
    country: "Россия",
    city: "Москва",
    registration_date: '03.06.2022',
    description:
        "С другой стороны, экономическая повестка сегодняшнего дня предоставляет широкие возможности для существующих финансовых и административных условий.",
  );
  // List<Dot> _filteredDots = [];

  // void setUser(List<String> filters) {
  //   _categories = filters;
  //   notifyListeners();
  // }

  void setData(UserType user) {
    _user = user;
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  UserType get user => _user;
  Author get userMeta => _userMeta;
}

class UserType {
  String country;
  String city;

  UserType({this.city = 'Москва', this.country = 'Россия'});
}
