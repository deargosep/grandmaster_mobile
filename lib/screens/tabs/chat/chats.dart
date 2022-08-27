import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    List chats = Provider.of<ChatsState>(context).chats;
    User user = Provider.of<UserState>(context).user;
    return CustomScaffold(
        noPadding: true,
        appBar: PreferredSize(
          preferredSize: Size(80, 80),
          child: AppHeader(
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
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: RefreshIndicator(
              onRefresh:
                  Provider.of<ChatsState>(context, listen: false).setChats,
              child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Get.toNamed('/chat', arguments: chats[index]);
                            },
                            child: ChatTile(chats[index])),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        )
                      ],
                    );
                  }),
            )));
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile(this.data, {Key? key}) : super(key: key);

  final ChatType data;

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
                  child: data.photo == null
                      ? CircleAvatar(
                          backgroundColor: Colors.black12,
                        )
                      : Avatar(data.photo!)),
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
                  data.lastMessage,
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
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
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
