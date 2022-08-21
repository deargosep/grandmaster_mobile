import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/dio.dart';

class GroupsState extends ChangeNotifier {
  List<GroupType> _groups = [];

  List _sportsmens = [];

  Future<List> setSportsmens() async {
    // log(data.toString());
    var response = await createDio().get('/sport_groups/sportsmen/');
    print(response.data);
    var data = response.data;
    print(data);
    _sportsmens = data;
    notifyListeners();
    return data;
  }

  List<GroupType> get groups => _groups;
  List get sportsmens => _sportsmens;

  void setGroups({List<GroupType>? data}) {
    if (data != null)
      _groups = data;
    else {
      createDio().get('/sport_groups/').then((value) {
        print(value);
        List<GroupType> newList = [
          ...value.data.map((e) {
            // DateTime newDate = DateTime.parse(e["created_at"]);
            return GroupType(
                id: e["id"],
                name: e["name"],
                trainer: e["trainer"],
                members: e["members"],
                maxAge: e["max_age"],
                minAge: e["min_age"]);
          }).toList()
        ];
        _groups = newList;
        notifyListeners();
      });
    }
    notifyListeners();
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
  final int minAge;
  final int maxAge;
  final List members;
  final int? trainer;

  GroupType(
      {required this.id,
      required this.name,
      required this.minAge,
      required this.maxAge,
      this.trainer,
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
