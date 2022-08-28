import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/choose_child.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatsState>(context, listen: false).setChats();
      Timer.periodic(Duration(seconds: 10), (timer) {
        if (mounted) Provider.of<ChatsState>(context, listen: false).setChats();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List chats = Provider.of<ChatsState>(context).chats;
    List chatsWithoutFolders =
        Provider.of<ChatsState>(context).chatsWithoutFolders;
    List chatsModerators = Provider.of<ChatsState>(context).moderatorsChats;
    List chatsTrainers = Provider.of<ChatsState>(context).trainersChats;
    List chatsStudents = Provider.of<ChatsState>(context).studentsChats;
    User user = Provider.of<UserState>(context).user;
    bool isLoaded = Provider.of<ChatsState>(context).isLoaded;
    return CustomScaffold(
        noPadding: true,
        appBar: PreferredSize(
          preferredSize: Size(80, 80),
          child: AppHeader(
            withBack: false,
            text: 'Чаты',
            icon: user.role == 'moderator' || user.role == 'trainer'
                ? 'plus'
                : '',
            iconOnTap: () {
              if (user.role == 'moderator' || user.role == 'trainer') {
                Get.toNamed('/chat/create');
              }
            },
          ),
        ),
        body: isLoaded
            ? chats.isNotEmpty
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: RefreshIndicator(
                          onRefresh:
                              Provider.of<ChatsState>(context, listen: false)
                                  .setChats,
                          child: ListView(
                            // shrinkWrap: true,
                            children: [
                              chatsModerators.isNotEmpty
                                  ? Column(
                                      children: [
                                        GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              Get.toNamed('/chat/folder',
                                                  arguments: 'moderators');
                                            },
                                            child: ChatTile(
                                              ChatType(
                                                  name: 'Модераторы',
                                                  lastMessage: '',
                                                  lastTime: '',
                                                  id: '',
                                                  unread: 0,
                                                  members: []),
                                              folder: true,
                                            )),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Column(
                                          children: [
                                            Divider(),
                                            SizedBox(
                                              height: 16,
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  : Container(),
                              chatsTrainers.isNotEmpty
                                  ? Column(
                                      children: [
                                        GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              Get.toNamed('/chat/folder',
                                                  arguments: 'trainers');
                                            },
                                            child: ChatTile(
                                                ChatType(
                                                    name: 'Тренеры',
                                                    lastMessage: '',
                                                    lastTime: '',
                                                    id: '',
                                                    unread: 0,
                                                    members: []),
                                                folder: true)),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Column(
                                          children: [
                                            Divider(),
                                            SizedBox(
                                              height: 16,
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  : Container(),
                              chatsStudents.isNotEmpty
                                  ? Column(
                                      children: [
                                        GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              Get.toNamed('/chat/folder',
                                                  arguments: 'students');
                                            },
                                            child: ChatTile(
                                                ChatType(
                                                    name: 'Студенты',
                                                    lastMessage: '',
                                                    lastTime: '',
                                                    id: '',
                                                    unread: 0,
                                                    members: []),
                                                folder: true)),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Column(
                                          children: [
                                            Divider(),
                                            SizedBox(
                                              height: 16,
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  : Container(),
                              chatsWithoutFolders.isNotEmpty
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: chatsWithoutFolders.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  if (Provider.of<UserState>(
                                                          context,
                                                          listen: false)
                                                      .user
                                                      .children
                                                      .isNotEmpty) {
                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.white,
                                                        isDismissible: false,
                                                        context: context,
                                                        builder: (context) =>
                                                            ChooseChild()).then(
                                                        (value) {
                                                      if (Provider.of<UserState>(
                                                                  context,
                                                                  listen: false)
                                                              .childId !=
                                                          '')
                                                        Get.toNamed('/chat',
                                                            arguments:
                                                                chatsWithoutFolders[
                                                                    index]);
                                                    });
                                                  } else {
                                                    Get.toNamed('/chat',
                                                        arguments:
                                                            chatsWithoutFolders[
                                                                index]);
                                                  }
                                                },
                                                child: ChatTile(
                                                    chatsWithoutFolders[
                                                        index])),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            index !=
                                                    chatsWithoutFolders.length -
                                                        1
                                                ? Column(
                                                    children: [
                                                      Divider(),
                                                      SizedBox(
                                                        height: 16,
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        );
                                      })
                                  : Container(),
                            ],
                          ),
                        )),
                  )
                : Center(
                    child: Text('Нет новостей'),
                  )
            : Center(child: CircularProgressIndicator()));
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile(this.data, {Key? key, this.folder = false}) : super(key: key);
  final bool folder;
  final ChatType data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            !folder
                ? Container(
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: data.photo == null
                            ? CircleAvatar(
                                backgroundColor: Colors.black12,
                              )
                            : Avatar(data.photo!)),
                  )
                : Container(),
            SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 160,
                  child: Text(
                    data.name,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF4F3333)),
                  ),
                ),
                !folder
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            data.lastMessage,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          )
                        ],
                      )
                    : Container(),
              ],
            ),
          ],
        ),
        Container(
          height: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.lastTime,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              data.type != 'system'
                  ? Container()
                  : SizedBox(
                      height: 8,
                    ),
              data.unread == 0
                  ? Container()
                  : Container(
                      height: 15,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 0.5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Center(
                        child: Text(data.unread.toString(),
                            style: TextStyle(color: Colors.white, height: 1.1)),
                      ),
                    ),
            ],
          ),
        )
      ],
    );
  }
}

class ChatData {
  bool isGroup;
  bool isSystem;
  List members;
  String name;
  List<MessageType> messages;

  ChatData(
      {this.isGroup = false,
      this.isSystem = false,
      members,
      messages,
      required this.name})
      : messages = messages ?? [],
        members = members ?? [];
}
