import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:intl/intl.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatData chatData(index) {
      switch (index) {
        case 0:
          return ChatData(name: "Игорь Федотов", isGroup: false);
        case 1:
          return ChatData(name: "Соревнования", isGroup: true, members: [
            {"username": "Lisa"},
            {"username": "Artem"},
          ]);
        case 2:
          return ChatData(
              name: "Группа 0401",
              isGroup: true,
              isSystem: true,
              members: [
                {"username": "Lisa"},
                {"username": "Artem"},
              ]);
        default:
          return ChatData(name: "Игорь Афотьев", isGroup: false);
      }
    }

    return CustomScaffold(
        noPadding: true,
        appBar: PreferredSize(
          preferredSize: Size(80, 80),
          child: AppHeader(
            text: 'Чаты',
            icon: 'plus',
          ),
        ),
        body: Column(
          children: [
            Divider(
              height: 3,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ListView(children: [
                    SizedBox(
                      height: 16,
                    ),
                    ChatTile(chatData(0)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    ChatTile(chatData(1)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    ChatTile(chatData(2)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    )
                  ])),
            )
          ],
        ));
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile(this.data, {Key? key}) : super(key: key);

  final ChatData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: pass data to screen
        Get.toNamed('/chat', arguments: data);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(height: 60, width: 60, child: CircleAvatar()),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF4F3333)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    data.messages.isNotEmpty
                        ? data.messages.last.text
                        : 'Всем привет!',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
            ],
          ),
          Container(
            height: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.messages.isNotEmpty
                      ? DateFormat.Hm().format(data.messages.last.timedate)
                      : '15:24',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                !data.isSystem
                    ? Container()
                    : SizedBox(
                        height: 8,
                      ),
                !data.isSystem
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
                          child: Text('223',
                              style:
                                  TextStyle(color: Colors.white, height: 1.1)),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
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
