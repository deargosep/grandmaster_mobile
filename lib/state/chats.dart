import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/state/user.dart';
import 'package:intl/intl.dart';

import '../utils/dio.dart';

class ChatsState extends ChangeNotifier {
  List<ChatType> _chats = [];

  List<ChatType> get chats => _chats;

  MessageType getMessagefromJson(data) {
    var decoded = jsonDecode(data);
    print(decoded);
    return MessageType(
        user: decoded["message"]["author"]["full_name"],
        text: decoded["message"]["text"],
        photo: decoded["message"]["image"],
        timedate: DateTime.parse(decoded["message"]["created_at"]));
  }

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
              name: e["type"] == 'dm'
                  ? [...e["members"].map((e) => e).toList()]
                              .firstWhereOrNull((e) => !e["me"]) !=
                          null
                      ? [...e["members"].map((e) => e).toList()]
                          .firstWhereOrNull((e) => !e["me"])["full_name"]
                      : e["name"]
                  : e["name"],
              // name: e["type"] == 'dm'
              // ? e["members"].firstWhere((e) => !e["me"])["full_name"]
              // : e["name"],
              lastMessage: e["last_message"]["text"],
              unread: e["unreaded_count"],
              photo: e["cover"] ?? e["type"] == 'dm'
                  ? [...e["members"].map((e) => e).toList()]
                              .firstWhereOrNull((e) => !e["me"]) !=
                          null
                      ? [...e["members"].map((e) => e).toList()]
                          .firstWhereOrNull((e) => !e["me"])["photo"]
                      : null
                  : null,
              // ?? e["type"] == 'dm'
              // ? e["members"].firstWhere((e) => !e["me"])["photo"]
              // : null,
              type: e["type"] == 'auto'
                  ? 'system'
                  : e["type"] == 'custom'
                      ? 'group'
                      : e["type"],
              lastTime: e["last_message"]["created_at"] != null
                  ? DateFormat('H:mm')
                      .format(DateTime.parse(e["last_message"]["created_at"]))
                  : '',
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
