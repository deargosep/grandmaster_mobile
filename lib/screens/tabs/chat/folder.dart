import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import 'chats.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({Key? key}) : super(key: key);

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Provider.of<ChatsState>(context, listen: false).setChats();
    });
  }

  var folder = Get.arguments;

  @override
  Widget build(BuildContext context) {
    List chats = Provider.of<ChatsState>(context).chats;
    List chatsWithoutFolders =
        Provider.of<ChatsState>(context).chatsWithoutFolders;
    List chatsModerators = Provider.of<ChatsState>(context).moderatorsChats;
    List chatsTrainers = Provider.of<ChatsState>(context).trainersChats;
    List chatsStudents = Provider.of<ChatsState>(context).studentsChats;
    List chatsSpecialists = Provider.of<ChatsState>(context).specialistsChat;
    if (folder == 'trainers') chatsWithoutFolders = chatsTrainers;
    if (folder == 'moderators') chatsWithoutFolders = chatsModerators;
    if (folder == 'students') chatsWithoutFolders = chatsStudents;
    if (folder == 'specialists') chatsWithoutFolders = chatsSpecialists;
    User user = Provider.of<UserState>(context).user;
    bool isLoaded = Provider.of<ChatsState>(context).isLoaded;
    return CustomScaffold(
        noPadding: true,
        appBar: PreferredSize(
          preferredSize: Size(80, 80),
          child: AppHeader(
              withBack: true,
              text: folder == 'trainers'
                  ? 'Тренеры'
                  : folder == 'moderators'
                      ? 'Модераторы'
                      : folder == 'students'
                          ? 'Студенты'
                          : folder == 'specialists'
                              ? 'Специалисты'
                              : ''),
        ),
        body: isLoaded
            ? chats.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: RefreshIndicator(
                      onRefresh: Provider.of<ChatsState>(context, listen: false)
                          .setChats,
                      child: chatsWithoutFolders.isNotEmpty
                          ? ListView.builder(
                              itemCount: chatsWithoutFolders.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          Get.toNamed('/chat',
                                              arguments:
                                                  chatsWithoutFolders[index]);
                                        },
                                        child: ChatTile(
                                            chatsWithoutFolders[index])),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    index != chatsWithoutFolders.length - 1
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
                    ))
                : Center(
                    child: Text('Нет чатов'),
                  )
            : Center(child: CircularProgressIndicator()));
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
