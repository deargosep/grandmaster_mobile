import 'package:flutter/material.dart';
import 'package:grandmaster/state/news.dart';

class UserState extends ChangeNotifier {
  User _userMeta = User(
    id: "12222",
    role: "moderator",
    name: "Глухарь",
    phoneNumber: '+7 (900) 993-45-76',
    fullName: 'Глухарев Глухарь Глухарьевич',
    birthday: '03.06.2000',
    gender: 'Мужчина',
    children: [
      User(
        id: "12223",
        name: "Иван",
        fullName: 'Иванов Иван Иванович',
        birthday: '03.06.2000',
        gender: 'Мужчина',
        age: 12,
        country: "Россия",
        city: "Москва",
        registration_date: '03.06.2022',
      ),
      User(
        id: "12224",
        name: "Иван",
        fullName: 'Иванов Иван Иванович',
        birthday: '03.06.2000',
        gender: 'Мужчина',
        age: 11,
        country: "Россия",
        city: "Москва",
        registration_date: '03.06.2022',
      ),
    ],
    age: 24,
    country: "Россия",
    city: "Москва",
    registration_date: '03.06.2022',
  );
  // List<Dot> _filteredDots = [];

  // void setUser(List<String> filters) {
  //   _categories = filters;
  //   notifyListeners();
  // }

  // void setData(UserType user) {
  //   _user = user;
  //   notifyListeners();
  // }

  /// Removes all items from the cart.
  void removeAll() {
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  User get user => _userMeta;
}

//
// class Passport {
//   final String birthday;
//   Passport({
//     fullName
// });
// }
