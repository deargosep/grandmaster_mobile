import 'package:flutter/material.dart';

import 'input.dart';

class SearchInput extends StatelessWidget {
  SearchInput(
      {Key? key,
      this.onChanged,
      required this.controller,
      this.onComplete,
      this.onTap})
      : super(key: key);
  VoidCallback? onChanged;
  TextEditingController controller;
  Function(String text)? onComplete;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: controller,
      onFieldSubmitted: (text) {
        onComplete!(text);
      },
      height: 40.0,
      label: 'Поиск',
      onTapIcon: () {
        controller.text = '';
        onComplete!(controller.text);
      },
      validator: (text) => null,
      icon: 'decline',
    );
  }
}

Map<String, bool> filterUsers(String text, Map<String, bool> initCheckboxes,
    Map<String, bool> oldCheckboxes) {
  Map<String, bool> newCheckboxes = initCheckboxes;
  Iterable<MapEntry<String, bool>> oldEntries = oldCheckboxes.entries;
  Iterable<MapEntry<String, bool>> entries = newCheckboxes.entries.where(
      (element) => element.key
          .split('_')[1]
          .toLowerCase()
          .contains(text.trim().toLowerCase()));
  Map<String, bool> filteredMap = {};
  filteredMap.addEntries(entries);
  filteredMap.addEntries(oldEntries.where((element) =>
      element.key
          .split('_')[1]
          .toLowerCase()
          .contains(text.trim().toLowerCase()) ||
      element.value));
  if (text.trim() != '') {
    Map<String, bool> sortedMap = Map.fromEntries(filteredMap.entries.toList()
      ..sort((e1, e2) {
        if (e2.value) {
          return 1;
        }
        return -1;
      }));
    return sortedMap;
  } else {
    return filteredMap;
  }
}
