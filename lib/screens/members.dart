import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:provider/provider.dart';

import '../utils/custom_scaffold.dart';
import '../utils/dio.dart';
import '../widgets/images/circle_logo.dart';
import 'tabs/chat/chat.dart';

class MembersScreen extends StatelessWidget {
  MembersScreen({Key? key}) : super(key: key);
  bool isOwner = Get.arguments["isOwner"];
  var id = Get.arguments["id"];
  Map item = Get.arguments;
  List<MinimalUser> members = Get.arguments["members"];
  @override
  Widget build(BuildContext context) {
    // print(id);
    // print(item);
    return CustomScaffold(
        appBar: AppHeader(
          text: 'Список участников',
        ),
        body: Column(
          children: [
            Divider(
              height: 0,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: members.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (members[index].id !=
                        Provider.of<UserState>(context, listen: false)
                            .user
                            .id) {
                      createDio()
                          .get('/users/${members[index].id}/')
                          .then((value) {
                        // log(value.data.toString());
                        User user = UserState().convertMapToUser(value.data);
                        Get.toNamed('/other_profile', arguments: user);
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: Row(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  child: members[index].photo != null
                                      ? Avatar(
                                          members[index].photo!,
                                          height: 45,
                                          width: 45,
                                        )
                                      : CircleLogo(
                                          height: 45,
                                          width: 45,
                                        )),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  members[index].fullName,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer),
                                ),
                              ),
                            ),
                            Builder(builder: (context) {
                              if (!isOwner) return Container();
                              if (members[index].id ==
                                  Provider.of<UserState>(context, listen: false)
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
          ],
        ));
  }
}
