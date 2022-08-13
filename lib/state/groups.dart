import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';

class GroupsState extends ChangeNotifier {
  List<GroupType> _groups = [
    GroupType(id: "123adssdad3", name: "Группа 0401", aging: [
      9,
      14
    ], members: [
      User(
          id: "12223",
          name: "Иван",
          fullName: 'Иванов Иван Иванович2',
          birthday: '03.06.2000',
          gender: 'Мужчина',
          age: 12,
          country: "Россия",
          city: "Москва",
          registration_date: '03.06.2022',
          passport: Passport()),
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
          passport: Passport()),
    ]),
  ];

  List<GroupType> get groups => _groups;

  void setGroups(List<GroupType> groups) {
    _groups = groups;
  }

  GroupType? getGroups(id) {
    return _groups.firstWhereOrNull((element) => element.id == id);
  }

  /// Removes all items from the cart.
  void removeAll() {
    _groups.clear();
    notifyListeners();
  }
}

class GroupType {
  final id;
  final name;
  final List<int> aging;
  final List<User> members;

  GroupType(
      {required this.id,
      required this.name,
      required this.aging,
      required this.members});
}

class ScheduleListType {
  final List<String> monday;
  final List<String> tuesday;
  final List<String> wednesday;
  final List<String> friday;
  final List<String> saturday;
  final List<String> sunday;

  ScheduleListType({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });
}
