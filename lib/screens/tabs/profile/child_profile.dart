import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/screens/tabs/profile/profile.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:provider/provider.dart';

import '../../../state/user.dart';
import '../../../utils/custom_scaffold.dart';
import '../../../widgets/tabbar_switch.dart';
import '../../../widgets/top_tab.dart';
import 'my_profile.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({Key? key}) : super(key: key);

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen>
    with TickerProviderStateMixin {
  late final User user;
  late TabController controller;
  bool isLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoaded = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      createDio().get('/users/${Get.arguments.id}/').then((value) {
        var e = value.data;
        setState(() {
          user = Provider.of<UserState>(context, listen: false)
              .convertMapToUser(e);
          isLoaded = true;
        });
        controller = TabController(length: 2, vsync: this);
      });
    });
  }

  final green = Color(0xFF44E467);
  final red = Color(0xFFE44444);

  @override
  Widget build(BuildContext context) {
    if (!isLoaded)
      return CustomScaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    return DefaultTabController(
      length: 2,
      child: CustomScaffold(
        bottomNavigationBar: BottomBarWrap(currentTab: 3),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              // SliverToBoxAdapter(child: _buildCarousel()),
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Positioned(
                        left: 20,
                        top: 50,
                        child: BrandIcon(
                          icon: 'back_arrow',
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                    Column(
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        Container(
                            height: 136,
                            width: 136,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: user.photo != null
                                  ? Avatar(
                                      user.photo!,
                                      height: 136,
                                      width: 136,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.black12,
                                    ),
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          user.fullName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 33,
                        ),
                        user.passport.sport_qualification != null &&
                                (user.passport.sport_qualification != '' &&
                                    user.passport.sport_qualification !=
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
                        Container(
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
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 18,
                                width: 18,
                                child: CircleAvatar(
                                  backgroundColor: !user.admitted ? red : green,
                                )),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              !user.admitted ? 'Не допущен' : 'Допущен',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Divider(),
                        SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 32),
                          child: TabsSwitch(
                            controller: controller,
                            children: [
                              TopTab(
                                text: 'Информация',
                              ),
                              TopTab(
                                text: 'Паспорт',
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Info(
                    user: user,
                  ),
                ),
                PassportInfo(user: user)
              ]),
        ),
      ),
    );
  }
}
