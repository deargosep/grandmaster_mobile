import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  bool seen = false;
  @override
  Widget build(BuildContext context) {
    ChatData chatData(index) {
      if (index == 1) return ChatData(name: 'Ребята от 12-18', isGroup: true);
      if (index == 2) return ChatData(name: '6-12 лет', isGroup: true);
      if (index == 3)
        return ChatData(name: 'Возрастная группа 7-14 лет', isGroup: true);
      var user = Provider.of<UserState>(context, listen: false).user;
      return ChatData(name: 'Руслан Игоревич', messages: [
        MessageType(
            user: user.fullName,
            text: seen ? '👍' : 'Как у тебя дела?',
            timedate: DateTime.now())
      ]);
      // switch (index) {
      //   case 0:
      //     return ChatData(name: "Игорь Федотов", isGroup: false);
      //   case 1:
      //     return ChatData(name: "Соревнования", isGroup: true, members: [
      //       {"username": "Lisa"},
      //       {"username": "Artem"},
      //     ]);
      //   case 2:
      //     return ChatData(
      //         name: "Группа 0401",
      //         isGroup: true,
      //         isSystem: true,
      //         members: [
      //           {"username": "Lisa"},
      //           {"username": "Artem"},
      //         ]);
      //   default:
      //     return ChatData(name: "Игорь Афотьев", isGroup: false);
      // }
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
                    GestureDetector(
                        onTap: () {
                          Get.toNamed('/chat', arguments: chatData(0));
                          setState(() {
                            seen = true;
                          });
                        },
                        child: ChatTile(chatData(0))),
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
                    ),
                    ChatTile(chatData(3)),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 60,
              width: 60,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: data.name == 'Руслан Игоревич'
                      ? Image.asset('assets/images/avatar.jpeg')
                      : CircleAvatar(
                          backgroundColor: Colors.black12,
                        )),
            ),
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
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
                    ? DateFormat('H:m').format(data.messages.last.timedate)
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
