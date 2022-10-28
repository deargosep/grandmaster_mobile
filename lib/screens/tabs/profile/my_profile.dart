import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/screens/tabs/profile/profile.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/images/circle_logo.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/custom_scaffold.dart';
import '../../../widgets/tabbar_switch.dart';
import '../../../widgets/top_tab.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key, this.showPassport = false})
      : super(key: key);
  final bool showPassport;
  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
    controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  final green = Color(0xFF44E467);
  final red = Color(0xFFE44444);
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    if (widget.showPassport) {
      user = Get.arguments;
    }
    bool isAdmitted() {
      return user.admitted;
    }

    if (user.role == 'moderator' || user.role == 'specialist')
      return CustomScaffold(
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
                height: 136,
                width: 136,
                child: user.photo != null
                    ? Avatar(
                        user.photo!,
                        height: 136,
                        width: 136,
                      )
                    : CircleLogo(
                        height: 136,
                        width: 136,
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
          ],
        ),
      );
    return DefaultTabController(
      length: 2,
      child: CustomScaffold(
        bottomNavigationBar: user.children.isNotEmpty
            ? BottomBarWrap(
                currentTab: 3,
              )
            : null,
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              // SliverToBoxAdapter(child: _buildCarousel()),
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Get.currentRoute == '/bar'
                        ? Container()
                        : Positioned(
                            child: BrandIcon(
                              icon: 'back_arrow',
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            top: 40,
                            left: 25,
                          ),
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
                                  : CircleLogo(
                                      height: 136,
                                      width: 136,
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
                        user.passport.tech_qualification != null &&
                                (user.passport.tech_qualification != '' &&
                                    user.passport.tech_qualification !=
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
                        user.role != 'trainer' || user.children.isEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 18,
                                      width: 18,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            !isAdmitted() ? red : green,
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    !isAdmitted() ? 'Не допущен' : 'Допущен',
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
                        SizedBox(
                          height: 24,
                        ),
                        Divider(),
                        SizedBox(
                          height: 32,
                        ),
                        user.children.isEmpty
                            ? Padding(
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
                              )
                            : Container(),
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
              children: user.children.isEmpty
                  ? [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Info(
                          user: user,
                        ),
                      ),
                      PassportInfo(user: user)
                    ]
                  : [Container()]),
        ),
      ),
    );
  }
}

class PassportInfo extends StatelessWidget {
  PassportInfo({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    var passport = user.passport;
    return ListView(
      shrinkWrap: true,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Item(
                name: "ФИО",
                value: passport.fio,
                ifNullRed: user.role == 'trainer',
                isTrainer: user.role == 'trainer',
              ),
              _Item(
                name: "Дата рождения",
                ifNullRed: true,
                value: user.birthday != null
                    ? DateFormat('dd.MM.y').format(user.birthday!)
                    : '',
                isTrainer: user.role == 'trainer',
              ),
              _Item(
                name: "Телефон",
                ifNullRed: user.role == 'trainer',
                value: passport.phoneNumber,
                isTrainer: user.role == 'trainer',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 32 - 24,
        ),
        Divider(),
        SizedBox(
          height: 32,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Item(
                name: "Спортшкола, клуб",
                ifNullRed: user.role != 'trainer',
                value: passport.sport_school,
                isTrainer: user.role == 'trainer',
              ),
              user.role != 'trainer'
                  ? _Item(
                      name: "Ведомство",
                      ifNullRed: true,
                      value: passport.vedomstvo,
                    )
                  : Container(),
              user.role != 'trainer'
                  ? _Item(
                      name: "Тренер",
                      ifNullRed: true,
                      value: passport.trainer,
                    )
                  : Container(),
              user.role != 'trainer'
                  ? _Item(
                      name: "Место тренировок",
                      ifNullRed: true,
                      value: passport.place_of_training,
                    )
                  : Container(),
              _Item(
                name: "Техническая квалификация",
                ifNullRed: true,
                value: passport.tech_qualification,
                isTrainer: user.role == 'trainer',
              ),
              _Item(
                name: "Спортивная квалификация",
                ifNullRed: user.role != 'trainer',
                value: passport.sport_qualification,
                isTrainer: user.role == 'trainer',
              ),
              user.role != 'trainer'
                  ? _Item(
                      name: "Рост (см)",
                      ifNullRed: true,
                      value: passport.height,
                    )
                  : Container(),
              user.role != 'trainer'
                  ? _Item(
                      name: "Вес (кг)",
                      ifNullRed: true,
                      value: passport.weight,
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(
          height: 32 - 24,
        ),
        Divider(),
        SizedBox(
          height: 32,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Item(
                name: "Город",
                ifNullRed: true,
                value: passport.city,
                isTrainer: user.role == 'trainer',
              ),
              _Item(
                name: "Адрес (ул., дом, кв.)",
                ifNullRed: true,
                value: passport.address,
                isTrainer: user.role == 'trainer',
              ),
              user.role != 'trainer'
                  ? _Item(
                      name: "Место учебы (город, школа)",
                      ifNullRed: true,
                      value: passport.school,
                    )
                  : Container(),
              _Item(
                name: "Медицинская справка / Дата окончания",
                ifNullRed: true,
                value: passport.med_spravka_date,
                isTrainer: user.role == 'trainer',
              ),
              _Item(
                name: "Страховой полис / Дата окончания",
                ifNullRed: true,
                value: passport.strah_date,
                isTrainer: user.role == 'trainer',
              ),
            ],
          ),
        ),
        user.role != 'trainer'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32 - 24,
                  ),
                  Divider(),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Item(
                          name: "Отец (ФИО)",
                          value: passport.father_fio,
                        ),
                        _Item(
                          name: "Отец (дата рождения)",
                          value: passport.father_birthday,
                        ),
                        _Item(
                          name: "Отец (телефон)",
                          value: passport.father_phoneNumber,
                        ),
                        _Item(
                          name: "Отец (e-mail)",
                          value: passport.father_email,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32 - 24,
                  ),
                  Divider(),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Item(
                          name: "Мать (ФИО)",
                          value: passport.mother_fio,
                        ),
                        _Item(
                          name: "Мать (дата рождения)",
                          value: passport.mother_birthday,
                        ),
                        _Item(
                          name: "Мать (телефон)",
                          value: passport.mother_phoneNumber,
                        ),
                        _Item(
                          name: "Мать (e-mail)",
                          value: passport.mother_email,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
        SizedBox(
          height: 95 - 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BrandButton(
            text: 'Документы',
            onPressed: () {
              Get.toNamed('/my_profile/documents', arguments: user);
            },
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class _Item extends StatelessWidget {
  _Item(
      {Key? key,
      required this.name,
      this.value,
      this.ifNullRed = false,
      this.isTrainer = false})
      : super(key: key);
  final String name;
  final value;
  final bool ifNullRed;
  final bool isTrainer;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondaryContainer;
    if (value == null && !ifNullRed) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
              color: value == null && ifNullRed
                  ? isTrainer
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 8,
        ),
        value != null && name.toLowerCase().contains('телефон')
            ? GestureDetector(
                onTap: () {
                  launchUrlString('tel:${value}');
                },
                child: Text(
                  "${value ?? "Необходимо заполнить"}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: value == null && ifNullRed
                          ? isTrainer
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).primaryColor
                          : Color(0xFF2674E9)),
                ),
              )
            : value != null &&
                    (name.toLowerCase().contains('справка') ||
                        name.toLowerCase().contains('полис'))
                ? Text(
                    "${value ?? "Необходимо заполнить"}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: (DateFormat('dd.MM.y')
                                        .parse(value)
                                        .isBefore(DateTime.now()) ||
                                    DateFormat('dd.MM.y')
                                        .parse(value)
                                        .isAtSameMomentAs(DateTime.now())) &&
                                ifNullRed
                            ?
                            // isTrainer
                            Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.secondary
                        // : Theme.of(context).colorScheme.secondary
                        ),
                  )
                : Text(
                    "${value ?? "Необходимо заполнить"}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: value == null && ifNullRed
                            ? isTrainer
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.secondary),
                  ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
