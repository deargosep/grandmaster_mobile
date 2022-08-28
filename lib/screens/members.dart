import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:provider/provider.dart';

import '../utils/custom_scaffold.dart';
import '../utils/dio.dart';
import 'tabs/chat/chat.dart';

class MembersScreen extends StatelessWidget {
  MembersScreen({Key? key}) : super(key: key);
  bool isOwner = Get.arguments["isOwner"];
  var id = Get.arguments["id"];
  Map item = Get.arguments;
  @override
  Widget build(BuildContext context) {
    List<MinimalUser> members = Provider.of<ChatsState>(context)
        .chats
        .firstWhere((element) => element.id == id)
        .members;
    if (item == null)
      return CustomScaffold(
        body: Container(),
      );
    return CustomScaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(
          0, 38 + MediaQuery.of(context).viewInsets.top, 0, 0),
      child: Column(
        children: [
          Header(
            text: 'Список участников чата',
          ),
          SizedBox(
            height: 32,
          ),
          Divider(
            height: 0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                itemCount: members
                    .where((element) =>
                        element.id !=
                        Provider.of<UserState>(context, listen: false).user.id)
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  if (members[index].id ==
                      Provider.of<UserState>(context, listen: false).user.id)
                    return Container();
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      createDio()
                          .get('/users/${members[index].id}/')
                          .then((value) {
                        log(value.data.toString());
                        User user = UserState().convertMapToUser(value.data);
                        Get.toNamed('/other_profile', arguments: user);
                      });
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // TODO: image (backend)
                              Row(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        child: members[index].photo != null
                                            ? Avatar(members[index].photo!)
                                            : CircleAvatar(
                                                backgroundColor: Colors.black12,
                                              )),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    members[index].fullName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer),
                                  ),
                                ],
                              ),
                              Builder(builder: (context) {
                                if (!isOwner) return Container();
                                if (members[index].id ==
                                    Provider.of<UserState>(context,
                                            listen: false)
                                        .user
                                        .id) return Container();
                                return Row(
                                  children: [
                                    BrandIcon(
                                      height: 16,
                                      width: 16,
                                      icon: 'decline',
                                      onTap: () {
                                        createDio()
                                            .put(
                                                '/chats/remove/?chat=${id}&member=${members[index].id}')
                                            .then((value) {
                                          Provider.of<ChatsState>(context,
                                                  listen: false)
                                              .setChats();
                                        });
                                      },
                                      color: Color(0xFF4F3333),
                                    )
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}
