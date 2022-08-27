import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grandmaster/state/user.dart';

import '../utils/dio.dart';

class ChatsState extends ChangeNotifier {
  List<ChatType> _chats = [];

  List<ChatType> get chats => _chats;

  Future<void> setChats({List<ChatType>? data}) async {
    var completer = new Completer();
    createDio().get('/chats/').then((value) {
      print(value.data);
      List<ChatType> newList = [
        ...value.data.map((e) {
          log(e.toString());
          // DateTime newDate = DateTime.parse(e["created_at"]);
          return ChatType(
              id: e["id"],
              name: e["dm"]
                  ? e["members"].firstWhere((e) => !e["me"])["full_name"]
                  : e["name"],
              lastMessage: e["last_message"]["text"],
              unread: e["unreaded_count"],
              photo: e["cover"] ?? e["dm"]
                  ? e["members"].firstWhere((e) => !e["me"])["photo"]
                  : null,
              type: e["dm"] ? 'dm' : 'group',
              lastTime: '13:00',
              members: [
                ...e["members"]
                    .map((es) => MinimalUser(
                        fullName: es["full_name"],
                        id: es["id"],
                        photo: es["photo"],
                        role: UserState().getRole(es["contact_type"])))
                    .toList()
              ]);
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
  final List<MinimalUser> members;

  ChatType(
      {required this.id,
      required this.name,
      this.photo,
      required this.lastMessage,
      required this.lastTime,
      this.unread,
      required this.members,
      this.type = 'dm'});
}
