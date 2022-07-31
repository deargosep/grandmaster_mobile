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
              thickness: 2,
              color: Color(0xFFF3F3F3),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          index == 0
                              ? SizedBox(
                                  height: 16,
                                )
                              : Container(),
                          ChatTile(index),
                          SizedBox(
                            height: 16,
                          ),
                          Divider(
                            thickness: 2,
                            color: Color(0xFFF8F8F8),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      );
                    }),
              ),
            )
          ],
        ));
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    ChatData chatArgs = ChatData(
        isGroup: !index.isOdd,
        members: index.isOdd
            ? []
            : [
                {"username": "Lisa"},
                {"username": "Artem"},
              ],
        name: index.isOdd ? "Игорь Федотов" : "Соревнования");
    return GestureDetector(
      onTap: () {
        // TODO: pass data to screen
        Get.toNamed('/chat', arguments: chatArgs);
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
                    chatArgs.name,
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
                    chatArgs.messages.isNotEmpty
                        ? chatArgs.messages.last.text
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
                  chatArgs.messages.isNotEmpty
                      ? DateFormat.Hm().format(chatArgs.messages.last.timedate)
                      : '15:24',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                index.isOdd
                    ? Container()
                    : SizedBox(
                        height: 8,
                      ),
                index.isOdd
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
  bool isSystemGroup;
  List members;
  String name;
  List<MessageType> messages;

  ChatData(
      {this.isGroup = false,
      this.isSystemGroup = false,
      members,
      messages,
      required this.name})
      : messages = messages ?? [],
        members = members ?? [];
}
