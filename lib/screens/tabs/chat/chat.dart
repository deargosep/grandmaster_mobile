import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../utils/custom_scaffold.dart';
import '../../../widgets/input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    if (_scrollController.hasClients)
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // late final currentUser = Provider.of<UserState>(context).user.username;
  ChatType chat = Get.arguments;

  List<MessageType> messages = [
    // MessageType(
    //     user: "Руслан Игоревич",
    //     text: "Как у тебя дела?",
    //     timedate: DateTime.now().subtract(Duration(days: 2))),
  ];

  bool isLoaded = false;

  late WebSocketChannel channel;
  @override
  void initState() {
    super.initState();
    // .initSocket(connectListener, messageListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatsState>(context, listen: false).setChats(
          childId: Provider.of<UserState>(context, listen: false).childId);
      SharedPreferences.getInstance().then((value) {
        channel = WebSocketChannel.connect(
          Uri.parse(
            'wss://app.grandmaster.center/ws/chat/${chat.id}/?token=${value.getString('access')}',
            // 'ws://app.grandmaster.center/ws/chat/${chat.id}/?token=${value.getString('access')}'
          ),
        );
        channel.stream.listen((event) {
          List<MessageType> newMessages = [...messages];
          newMessages.insert(
              0, ChatsState().getMessagefromJson(event.toString()));
          setState(() {
            messages = newMessages;
          });
        });
      });
      setState(() {
        isLoaded = true;
      });
      createDio().get('/chats/messages/?chat=${chat.id}').then((value) {
        print(value.data);
        List<MessageType> newMessages = [...messages];
        if (value.data.isNotEmpty) {
          newMessages.addAll([
            ...value.data.map((e) => MessageType(
                user: e["author"]["full_name"],
                text: e["text"],
                photo: e["image"],
                prefix: e["prefix"],
                timedate: DateTime.parse(e["created_at"])))
          ]);
          setState(() {
            messages = newMessages;
          });
        }
      });
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
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onChangedSM(text, photo) {
      // List<MessageType> newMessages = [...messages];
      // newMessages.add(MessageType(
      //     user: Provider.of<UserState>(context, listen: false).user.fullName,
      //     text: text,
      //     timedate: DateTime.now()));
      // setState(() {
      //   messages = newMessages;
      // });
      if (text != '' || photo != '')
        channel.sink.add(jsonEncode({
          "message": {
            "text": text,
            "photo": photo,
            "id": Provider.of<UserState>(context, listen: false).childId
          }
        }));
      // showErrorSnackbar('Не удалось отправить сообщение');

      // setState(() {
      //   messages = newMessages;
      // });
      // Timer(Duration(seconds: 3), () {
      //   var newMessages = [...messages];
      //   newMessages.add(MessageType(
      //       user: 'Руслан Игоревич', text: '👍', timedate: DateTime.now()));
      //   setState(() {
      //     messages = newMessages;
      //   });
      // });
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

    return CustomScaffold(
        body: !isLoaded
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
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
                              shrinkWrap: true,
                              reverse: true,
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
                                      reverse: true,
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
                            )),
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
  ChatType chat = Get.arguments;
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
        // isMine()
        //     ? Container()
        //     : ClipRRect(
        //         borderRadius: BorderRadius.all(Radius.circular(100)),
        //         child: item.photo != null
        //             ? Avatar(item.photo!)
        //             : CircleAvatar(
        //                 backgroundColor: Colors.black12,
        //               )),
        // isMine()
        //     ? Container()
        //     : SizedBox(
        //         width: 12,
        //       ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isMine() ? Color(0xFFF6E8E8) : Color(0xFFF6F1F1),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            crossAxisAlignment:
                isMine() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              chat.type == 'group' && !isMine()
                  ? Column(
                      children: [
                        Text(
                          '${item.prefix ?? ''}${item.prefix != null ? ' ' : ''}${item.user}',
                          style: TextStyle(color: Color(0xFF9FA6BA)),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    )
                  : Container(),
              item.photo != null
                  ? GestureDetector(
                      onTap: () {
                        Get.toNamed('/chat/photo', arguments: item.photo);
                      },
                      child: Container(
                          height: 200,
                          width: 250,
                          child: LoadingImage(item.photo!)),
                    )
                  : Container(),
              item.text != ''
                  ? Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          item.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 8,
                    ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  DateFormat.Hm().format(item.timedate),
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 12, color: Color(0xFF9FA6BA)),
                ),
              )
            ],
          ),
        ),
        // !isMine()
        //     ? Container()
        //     : SizedBox(
        //         width: 12,
        //       ),
        // !isMine()
        //     ? Container()
        //     : Container(
        //         height: 50,
        //         width: 50,
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.all(Radius.circular(100))),
        //         child: null
        // Avatar(
        //               Provider.of<UserState>(context).user.photo!,
        //               height: 50,
        //               width: 50,
        //             )
        // ),
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
  XFile? photo;
  final _picker = ImagePicker();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void sendMessage(String text) async {
      controller.clear();
      widget.onChanged(
          text, photo != null ? base64Encode(await photo!.readAsBytes()) : '');
      setState(() {
        photo = null;
      });
    }

    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: photo != null ? 5 : 0),
          decoration: photo != null
              ? BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                )))
              : null,
          child: BrandIcon(
            icon: 'add',
            height: 25,
            width: 25,
            onTap: () {
              _picker
                  .pickImage(imageQuality: 60, source: ImageSource.gallery)
                  .then((value) {
                setState(() {
                  photo = value;
                });
              });
            },
          ),
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
        ),
        SizedBox(
          width: 16,
        ),
        InkWell(
          onTap: () {
            sendMessage(controller.text);
          },
          child: Icon(
            Icons.send,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}

class _Header extends StatelessWidget {
  _Header({Key? key}) : super(key: key);

  var id = Get.arguments.id;
  @override
  Widget build(BuildContext context) {
    ChatType chat = Provider.of<ChatsState>(context)
        .chats
        .firstWhere((element) => element.id == id);
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
            // SizedBox(
            //   width: 26,
            // ),
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100 / 2)),
                child: chat.photo != null
                    ? Avatar(chat.photo!)
                    : CircleAvatar(
                        backgroundColor: Colors.black12,
                      )),
            SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                if (chat.type == 'group') {
                  Get.toNamed('/members', arguments: {
                    "members": chat.members,
                    "id": chat.id,
                    "isOwner": chat.owner ==
                        Provider.of<UserState>(context, listen: false).user.id
                  });
                } else if (chat.type == 'dm') {
                  createDio()
                      .get(
                          '/users/${chat.members.firstWhere((element) => element.id != Provider.of<UserState>(context, listen: false).user.id).id}/')
                      .then((value) {
                    print([chat.members.map((e) => e.me)]);
                    User user = UserState().convertMapToUser(value.data);
                    Get.toNamed('/other_profile', arguments: user);
                  });
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 150,
                    child: Text(
                      chat.name,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  chat.type == 'group'
                      ? Text(
                          'Участники: ${chat.members.length}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              fontSize: 14),
                        )
                      : Container(),
                ],
              ),
            ),
            Spacer(),
            chat.type == 'group'
                ? BrandIcon(
                    icon: 'logout',
                    onTap: () {
                      createDio()
                          .get('/chats/leave/?chat=${chat.id}')
                          .then((value) {
                        Provider.of<ChatsState>(context, listen: false)
                            .setChats();
                        Get.back();
                      });
                    },
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
  String? photo;
  String? prefix;
  MessageType(
      {required this.user,
      this.photo,
      this.prefix,
      required this.text,
      required this.timedate});
}

class Avatar extends StatelessWidget {
  const Avatar(this.url, {Key? key, this.height, this.width}) : super(key: key);
  final String url;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        child: Image.network(
          url,
          height: height,
          width: width,
          loadingBuilder: (context, child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: height,
              width: width,
              child: Skeleton(
                isLoading: true,
                skeleton: SkeletonAvatar(
                  style: SkeletonAvatarStyle(shape: BoxShape.circle),
                ),
                child: Container(),
              ),
            );
          },
        ));
  }
}

// Map snapshots = snapshot.data!;
// map((e)=>{
//   "message":{"id": 9, "author": {"id": 214,
//     "full_name": "Романовна Яна ", "me": false},
//     "text":e["text"]
//   },
// });
// var snapshots =
//     snapshot.data;
// print(snapshots["message"]);
// var newMessages = [...messages];
// var newData = MessageType(
//     user: snapshots["message"]["author"]
//         ["full_name"],
//     text: snapshots["message"]["text"],
//     timedate: DateTime.parse(
//         snapshots["message"]["created_at"]));
// newMessages.add(newData);
// return Text(snapshot.data.toString());
