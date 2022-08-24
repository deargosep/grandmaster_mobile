import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chats.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../widgets/input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // late final currentUser = Provider.of<UserState>(context).user.username;
  ChatData chat = Get.arguments;

  List<MessageType> messages = [
    MessageType(
        user: "Руслан Игоревич",
        text: "Как у тебя дела?",
        timedate: DateTime.now().subtract(Duration(days: 2))),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // messages[
      //     Provider.of<UserState>(context, listen: false).user.fullName;
    });
  }

  List months = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря'
  ];
  @override
  Widget build(BuildContext context) {
    void onChangedSM(newMessages) {
      // showErrorSnackbar('Не удалось отправить сообщение');

      setState(() {
        messages = newMessages;
      });
      Timer(Duration(seconds: 3), () {
        var newMessages = [...messages];
        newMessages.add(MessageType(
            user: 'Руслан Игоревич', text: '👍', timedate: DateTime.now()));
        setState(() {
          messages = newMessages;
        });
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    String calculateDifference(DateTime date) {
      DateTime now = DateTime.now();
      int difference = DateTime(date.year, date.month, date.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
      var currentMonth = months[date.month - 1];
      var currentDay = date.day;
      switch (difference) {
        case 0:
          return 'Сегодня';
        case -1:
          return 'Вчера';
        case -2:
          return 'Позавчера';
        default:
          return "${currentDay} ${currentMonth}";
      }
    }

    Map<String, List<MessageType>> grouped =
        groupBy<MessageType, String>(messages, (message) {
      DateTime time = message.timedate;
      return "${time.year}-${time.month.toString().length == 1 ? "0" + time.month.toString() : time.month}-${time.day.toString().length == 1 ? "0" + time.day.toString() : time.day}";
    });

    return Scaffold(
        body: Column(
      children: [
        _Header(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: grouped.keys.length,
                  // reverse: true,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String date = grouped.keys.toList()[index];
                    List<MessageType> messages = grouped[date]!;
                    // int reverseIndex = messages.length - 1 - index;
                    DateTime parsed = DateTime.parse(date);
                    return Column(
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          calculateDifference(parsed),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        ListView.builder(
                          // reverse: true,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              Message(item: messages[index]),
                              SizedBox(
                                height: 16,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        BottomPanel(
            height: 83.0,
            child: SendMessage(
              messages: messages,
              onChanged: onChangedSM,
            ))
      ],
    ));
  }
}

class Message extends StatelessWidget {
  Message({Key? key, required this.item}) : super(key: key);
  final MessageType item;
  ChatData chat = Get.arguments;
  @override
  Widget build(BuildContext context) {
    bool isMine() {
      return item.user ==
          Provider.of<UserState>(context, listen: false).user.fullName;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !isMine() ? Container() : Spacer(),
        isMine()
            ? Container()
            : ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: CircleAvatar(
                  child: Image.asset('assets/images/avatar.jpeg'),
                )),
        isMine()
            ? Container()
            : SizedBox(
                width: 12,
              ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isMine() ? Color(0xFFF6E8E8) : Color(0xFFF6F1F1),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            crossAxisAlignment:
                isMine() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              chat.isGroup && !isMine()
                  ? Column(
                      children: [
                        Text(
                          item.user,
                          style: TextStyle(color: Color(0xFF9FA6BA)),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    )
                  : Container(),
              Text(
                item.text,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                DateFormat.Hm().format(item.timedate),
                style: TextStyle(fontSize: 12, color: Color(0xFF9FA6BA)),
              )
            ],
          ),
        ),
        !isMine()
            ? Container()
            : SizedBox(
                width: 12,
              ),
        !isMine()
            ? Container()
            : Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: Avatar(Provider.of<UserState>(context).user.photo!)),
      ],
    );
  }
}

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key, this.onChanged, this.messages})
      : super(key: key);
  final onChanged;
  final messages;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void sendMessage(String text) {
      controller.clear();
      print(text);
      // TODO: use actual user
      var localMessages = <MessageType>[
        ...widget.messages,
        MessageType(
            user: Provider.of<UserState>(context, listen: false).user.fullName,
            text: text,
            timedate: DateTime.now()),
      ];
      widget.onChanged(localMessages);
    }

    return Row(
      children: [
        BrandIcon(
          icon: 'add',
          height: 25,
          width: 25,
        ),
        SizedBox(
          width: 10.5,
        ),
        Expanded(
          child: Input(
            controller: controller,
            onFieldSubmitted: sendMessage,
            height: 40.0,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            label: 'Введите сообщение',
          ),
        )
      ],
    );
  }
}

class _Header extends StatelessWidget {
  _Header({Key? key}) : super(key: key);

  ChatData chat = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 114 + MediaQuery.of(context).viewPadding.top,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(
            16, 32 + MediaQuery.of(context).viewPadding.top, 16, 32),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0xFFF3F3F3), width: 2)),
            color: Colors.white),
        child: Row(
          children: [
            BrandIcon(
              icon: 'back_arrow',
              color: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(
              width: 26,
            ),
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100 / 2)),
                child: Image.asset('assets/images/avatar.jpeg')),
            SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chat.name,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                SizedBox(
                  height: 4,
                ),
                chat.isGroup
                    ? GestureDetector(
                        onTap: () {
                          Get.toNamed('/members', arguments: {
                            "members": chat.members,
                            "isOwner": true
                          });
                        },
                        child: Text(
                          'Участники: ${chat.members.length}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              fontSize: 14),
                        ))
                    : Container(),
              ],
            ),
            Spacer(),
            chat.isGroup && !chat.isSystem
                ? BrandIcon(
                    icon: 'logout',
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : Container()
          ],
        ));
  }
}

class MessageType {
  String user;
  String text;
  DateTime timedate;
  MessageType({required this.user, required this.text, required this.timedate});
}

class Avatar extends StatelessWidget {
  const Avatar(this.url, {Key? key}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100 / 2)),
        child: Image.network(
          url,
          loadingBuilder: (context, child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Skeleton(
              isLoading: true,
              skeleton: SkeletonAvatar(
                style: SkeletonAvatarStyle(shape: BoxShape.circle),
              ),
              child: Container(),
            );
          },
        ));
  }
}
