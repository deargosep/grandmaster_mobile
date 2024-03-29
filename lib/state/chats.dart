import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/state/user.dart';
import 'package:intl/intl.dart';

import '../utils/dio.dart';

class ChatsState extends ChangeNotifier {
  List<ChatType> _chats = [];
  List<ChatType> get chats => _chats;
  List<ChatType> get chatsWithoutFolders => getChats();
  List<ChatType> get trainersChats => getTrainersChats();
  List<ChatType> get specialistsChat => getSpecialistsChats();
  List<ChatType> get moderatorsChats => getModeratorsChats();
  List<ChatType> get studentsChats => getStudentsChats();
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  MessageType getMessagefromJson(data) {
    _isLoaded = false;
    var decoded = jsonDecode(data);
    return MessageType(
        fullName: decoded["message"]["author"]["full_name"],
        userId: decoded["message"]["author"]["id"],
        me: decoded["message"]["author"]["me"],
        text: decoded["message"]["text"],
        photo: decoded["message"]["image"],
        timedate: DateTime.parse(decoded["message"]["created_at"]));
  }

  List<ChatType> getChats() {
    List<ChatType> chats =
        _chats.where((element) => element.folder == 'none').toList();
    chats.sort((a, b) {
      if (b.isTrainerDM) {
        return 1;
      }
      return -1;
    });
    return chats;
  }

  List<ChatType> getSpecialistsChats() {
    return _chats.where((element) => element.folder == 'specialists').toList();
  }

  List<ChatType> getTrainersChats() {
    return _chats.where((element) => element.folder == 'trainers').toList();
  }

  List<ChatType> getStudentsChats() {
    return _chats.where((element) => element.folder == 'students').toList();
  }

  List<ChatType> getModeratorsChats() {
    return _chats.where((element) => element.folder == 'moderators').toList();
  }

  Future<void> setChats({List<ChatType>? data, childId}) async {
    var completer = new Completer();
    createDio()
        .get('/chats/${childId != null ? '?id=' : ''}${childId ?? ''}')
        .then((value) {
      List<ChatType> newList = [
        ...value.data.map((e) {
          // DateTime newDate = DateTime.parse(e["created_at"]);
          List<MinimalUser> members = [
            ...e["members"]
                .map((es) => MinimalUser(
                    fullName: es["full_name"],
                    id: es["id"],
                    photo: es["photo"],
                    role: UserState().getRole(es["contact_type"]),
                    me: es["me"]))
                .toList()
          ];
          members.sort((a, b) {
            return a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
          });
          return ChatType(
              id: e["id"],
              name: e["display_name"] ?? e["name"],
              folder: e["folder"],
              owner: e["owner"] != null ? e["owner"]["id"] : null,
              // name: e["type"] == 'dm'
              // ? e["members"].firstWhere((e) => !e["me"])["full_name"]
              // : e["name"],
              lastMessage: e["last_message"]["text"] ?? '',
              unread: e["unreaded_count"] ?? '',
              photo: e["type"] == 'dm'
                  ? members.firstWhereOrNull((e) => !e.me)?.photo
                  : e["cover"],
              type: e["type"] == 'auto'
                  ? 'system'
                  : e["type"] == 'custom'
                      ? 'group'
                      : e["type"],
              lastTime: e["last_message"]["created_at"] != null
                  ? DateFormat('H:mm')
                      .format(DateTime.parse(e["last_message"]["created_at"]))
                  : '',
              members: members,
              isTrainerDM: e["type"] == 'dm' &&
                  members.firstWhere((element) => !element.me).role ==
                      'trainer');
        }).toList()
      ];
      _chats = newList;
      notifyListeners();
      completer.complete();
    }).whenComplete(() {
      _isLoaded = true;
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
  final String folder;
  final owner;
  final bool isTrainerDM;

  ChatType(
      {required this.id,
      required this.name,
      this.photo,
      this.lastMessage = '',
      this.lastTime = '',
      this.unread,
      this.owner,
      required this.members,
      this.isTrainerDM = false,
      this.type = 'dm',
      this.folder = 'none'});
}
