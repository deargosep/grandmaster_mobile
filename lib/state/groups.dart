import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';

import '../utils/dio.dart';

class GroupsState extends ChangeNotifier {
  List<GroupType> _groups = [];
  List<MinimalUser> _sportsmens = [];
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<List<MinimalUser>> setSportsmens() async {
    _isLoaded = false;
    // var completer = new Completer();
    // log(data.toString());
    var response = await createDio().get('/sport_groups/sportsmen/');
    List<MinimalUser> data = [
      ...response.data
          .map((e) => MinimalUser(fullName: e["full_name"], id: e["id"]))
          .toList()
    ];
    data.sort((a, b) {
      return a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
    });
    _isLoaded = true;
    _sportsmens = data;
    notifyListeners();
    return data;
  }

  List<GroupType> get groups => _groups;
  List<MinimalUser> get sportsmens => _sportsmens;

  Future<void> setGroups() async {
    _isLoaded = false;
    var completer = new Completer();
    createDio().get('/sport_groups/').then((value) {
      List<GroupType> newList = [
        ...value.data.map((e) {
          // DateTime newDate = DateTime.parse(e["created_at"]);
          List<MinimalUser> members = [
            ...e["members"]
                .map((e) => MinimalUser(fullName: e["full_name"], id: e["id"]))
                .toList()
          ];
          members.sort((a, b) {
            return a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
          });
          return GroupType(
              id: e["id"],
              name: e["name"],
              trainer: e["trainer"],
              members: members,
              maxAge: e["max_age"],
              minAge: e["min_age"]);
        }).toList()
      ];
      _groups = newList;
      notifyListeners();
      completer.complete();
    }).whenComplete(() {
      _isLoaded = true;
    });
    return completer.future;
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
  final List<MinimalUser> members;
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
