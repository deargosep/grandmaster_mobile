import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/dio.dart';

class ChatsState extends ChangeNotifier {
  List<ChatType> _chats = [
    ChatType(
        id: '0',
        name: 'Андрей',
        lastMessage: 'Привет',
        lastTime: "13:00",
        type: 'dm'),
    ChatType(
        id: '0',
        name: 'Андрей Робот',
        lastMessage: 'Здравствуйте',
        lastTime: "9:41",
        unread: 223,
        type: 'system'),
  ];

  List<ChatType> get chats => _chats;

  Future<void> setChats({List<ChatType>? data}) async {
    var completer = new Completer();
    createDio().get('/chats/').then((value) {
      List<ChatType> newList = [
        ...value.data.map((e) {
          // DateTime newDate = DateTime.parse(e["created_at"]);
          print(e);
          return ChatType(
              id: e["id"],
              name: 'Андрей',
              lastMessage: 'Привет',
              lastTime: '13:00');
        }).toList()
      ];
      _chats = newList;
      notifyListeners();
      completer.complete();
    });
    return completer.future;
  }

  // AboutType? getNews(id) {
  //   return _about.firstWhereOrNull((element) => element.id == id);
  // }

  /// Removes all items from the cart.
  void removeAll() {
    _chats.clear();
    notifyListeners();
  }
}

class ChatType {
  final id;
  final String name;
  final String? photo;
  final String lastMessage;
  final String lastTime;
  final String type;
  final int? unread;

  ChatType(
      {required this.id,
      required this.name,
      this.photo,
      required this.lastMessage,
      required this.lastTime,
      this.unread,
      this.type = 'dm'});
}
