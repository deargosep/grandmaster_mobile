import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/tabbar_switch.dart';
import 'package:grandmaster/widgets/top_tab.dart';
import 'package:provider/provider.dart';

import '../state/user.dart';
import '../utils/custom_scaffold.dart';
import 'tabs/profile/my_profile.dart';
import 'tabs/profile/profile.dart';

class SomeoneProfile extends StatefulWidget {
  const SomeoneProfile({Key? key}) : super(key: key);

  @override
  State<SomeoneProfile> createState() => _SomeoneProfileState();
}

class _SomeoneProfileState extends State<SomeoneProfile>
    with TickerProviderStateMixin {
  late TabController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    User user = Get.arguments;
    return DefaultTabController(
      length: 2,
      child: CustomScaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 50,
                      child: BrandIcon(
                        icon: 'back_arrow',
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 50,
                      child: Container(
                          height: 136,
                          width: 136,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          child: user.photo != null
                              ? CircleAvatar(
                                  child: Avatar(
                                    user.photo!,
                                    height: 136,
                                    width: 136,
                                  ),
                                )
                              : Container()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          Text(
                            user.fullName,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 33,
                          ),
                          GestureDetector(
                            onTap: () {
                              createDio()
                                  .get('/chats/${user.chatId}/')
                                  .then((value) {
                                print(value.data);
                                Provider.of<ChatsState>(context, listen: false)
                                    .setChats(
                                        childId: Provider.of<UserState>(context,
                                                listen: false)
                                            .childId)
                                    .then((value) {
                                  Get.toNamed('/chat',
                                      arguments: Provider.of<ChatsState>(
                                              context,
                                              listen: false)
                                          .chats
                                          .firstWhere((element) =>
                                              element.id == user.chatId));
                                });
                              });
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color(0xFFFBF7F7),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              child: Center(
                                child: Text(
                                  'Написать сообщение',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Provider.of<UserState>(context).user.role ==
                                      'trainer' &&
                                  (user.role != 'trainer' ||
                                      user.role != 'moderator' ||
                                      user.role != 'specialist')
                              ? TabsSwitch(
                                  controller: controller,
                                  children: [
                                    TopTab(
                                      text: 'Информация',
                                    ),
                                    TopTab(
                                      text: 'Паспорт',
                                    )
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ];
          },
          body: Provider.of<UserState>(context).user.role == 'trainer' &&
                  (user.role != 'trainer' ||
                      user.role != 'moderator' ||
                      user.role != 'specialist')
              ? TabBarView(controller: controller, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Info(user: user),
                  ),
                  PassportInfo(user: user)
                ])
              : Container(),
        ),
      ),
    );
  }
}
