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

  final green = Color(0xFF44E467);
  final red = Color(0xFFE44444);
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
                          user.isMyStudent &&
                                  Provider.of<UserState>(context, listen: false)
                                          .user
                                          .role ==
                                      'trainer'
                              ? Column(
                                  children: [
                                    user.passport.sport_qualification != null &&
                                            (user.passport
                                                        .sport_qualification !=
                                                    '' &&
                                                user.passport
                                                        .sport_qualification !=
                                                    'Нет квалификации')
                                        ? Container(
                                            width: 300,
                                            child: Text(
                                              'Спортивная квалификация: ${user.passport.sport_qualification}',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondaryContainer,
                                                  fontSize: 14),
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    user.passport.tech_qualification != null &&
                                            (user.passport.tech_qualification !=
                                                    '' &&
                                                user.passport
                                                        .tech_qualification !=
                                                    'Нет квалификации')
                                        ? Container(
                                            width: 300,
                                            child: Text(
                                              'Техническая квалификация: ${user.passport.tech_qualification.toString()}',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondaryContainer,
                                                  fontSize: 14),
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    user.role != 'trainer'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  height: 18,
                                                  width: 18,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        !user.admitted
                                                            ? red
                                                            : green,
                                                  )),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                !user.admitted
                                                    ? 'Не допущен'
                                                    : 'Допущен',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondaryContainer,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(),
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
                  user.isMyStudent
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
