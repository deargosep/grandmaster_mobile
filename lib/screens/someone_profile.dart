import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/images/circle_logo.dart';
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
  bool isLoaded = true;
  User user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    print(user.id);
    print(Provider.of<UserState>(context, listen: false).user.id);
    return DefaultTabController(
      length: 2,
      child: CustomScaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                  child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Stack(children: [
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: BrandIcon(
                          icon: 'back_arrow',
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: user.photo != null
                              ? Avatar(
                                  user.photo!,
                                  height: 136,
                                  width: 136,
                                )
                              : CircleLogo(
                                  height: 136,
                                  width: 136,
                                ),
                        ),
                        Spacer()
                      ],
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          user.fullName,
                          textAlign: TextAlign.center,
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
                                          (user.passport.sport_qualification !=
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
                                  user.role != 'trainer' &&
                                          user.children.isEmpty
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
                                                  fontWeight: FontWeight.w500),
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
                          onTap: !isLoaded
                              ? null
                              : () {
                                  setState(() {
                                    isLoaded = false;
                                  });
                                  createDio()
                                      .get('/chats/${user.chatId}/')
                                      .then((value) {
                                    Provider.of<ChatsState>(context,
                                            listen: false)
                                        .setChats(
                                            childId: Provider.of<UserState>(
                                                    context,
                                                    listen: false)
                                                .childId)
                                        .then((value) {
                                      if (mounted)
                                        setState(() {
                                          isLoaded = true;
                                        });
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                !isLoaded
                                    ? Container(
                                        height: 20,
                                        width: 20,
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        child: CircularProgressIndicator(),
                                      )
                                    : Container(),
                                Text(
                                  'Написать сообщение',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        (Provider.of<UserState>(context).user.role ==
                                        'trainer' &&
                                    user.isMyStudent) ||
                                Provider.of<UserState>(context).user.role ==
                                    'moderator' ||
                                Provider.of<UserState>(context).user.role ==
                                    'specialist' ||
                                Provider.of<UserState>(context)
                                        .user
                                        .children
                                        .firstWhereOrNull((element) =>
                                            user.id == element.id) !=
                                    null ||
                                Provider.of<UserState>(context).user.id ==
                                    user.id
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
              ))
            ];
          },
          body: (Provider.of<UserState>(context).user.role == 'trainer' &&
                      user.isMyStudent) ||
                  Provider.of<UserState>(context).user.role == 'moderator' ||
                  Provider.of<UserState>(context).user.role == 'specialist' ||
                  Provider.of<UserState>(context)
                          .user
                          .children
                          .firstWhereOrNull(
                              (element) => user.id == element.id) !=
                      null ||
                  Provider.of<UserState>(context).user.id == user.id
              ? Padding(
                  padding: const EdgeInsets.only(top: kIsWeb ? 20 : 0),
                  child: TabBarView(controller: controller, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Info(user: user),
                    ),
                    PassportInfo(user: user)
                  ]),
                )
              : Container(),
        ),
      ),
    );
  }
}
