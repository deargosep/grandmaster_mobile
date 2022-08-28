import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/screens/tabs/profile/profile.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _pickedImage;

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
      return !user.admitted;
    }

    void getImage() {
      showDialog<ImageSource>(
        context: context,
        builder: (context) =>
            AlertDialog(content: Text("Choose image source"), actions: [
          FlatButton(
            child: Text("Camera"),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          FlatButton(
            child: Text("Gallery"),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ]),
      ).then((ImageSource? source) async {
        if (source != null) {
          final pickedFile = await ImagePicker().pickImage(source: source);
          setState(() {
            _pickedImage = File(pickedFile!.path);
          });
        }
      });
    }

    if (user.role == 'moderator' || user.children.isNotEmpty)
      return Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
                left: 20,
                top: 60,
                child: BrandIcon(
                  icon: 'back_arrow',
                  color: Theme.of(context).colorScheme.secondaryContainer,
                )),
            Positioned(
              left: 0,
              right: 0,
              top: 10,
              child: Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                      height: 136,
                      width: 136,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
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
                ],
              ),
            ),
          ],
        ),
      );
    return DefaultTabController(
      length: 2,
      child: CustomScaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              // SliverToBoxAdapter(child: _buildCarousel()),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                        height: 136,
                        width: 136,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
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
                    user.role != 'trainer'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 18,
                                  width: 18,
                                  child: CircleAvatar(
                                    backgroundColor: isAdmitted() ? red : green,
                                  )),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                isAdmitted() ? 'Не допущен' : 'Допущен',
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
                            text:
                                'Паспорт ${user.role == 'trainer' ? '' : "спортсмена"}',
                          )
                        ],
                      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Item(
                name: "ФИО",
                value: passport.fio,
              ),
              _Item(
                name: "Дата рождения",
                value: user.birthday != null
                    ? DateFormat('d.MM.y').format(user.birthday!)
                    : '',
              ),
              _Item(
                name: "Телефон",
                value: passport.phoneNumber,
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
                value: passport.sport_school,
              ),
              _Item(
                name: "Ведомство",
                value: passport.vedomstvo,
              ),
              _Item(
                name: "Место тренировок",
                value: passport.place_of_training,
              ),
              _Item(
                name: "Техническая квалификация",
                value: passport.tech_qualification,
              ),
              _Item(
                name: "Спортивная квалификация",
                value: passport.sport_qualification,
              ),
              _Item(
                name: "Рост (см)",
                value: passport.height,
              ),
              _Item(
                name: "Вес (кг)",
                value: passport.weight,
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
                name: "Регион",
                value: passport.region,
              ),
              _Item(
                name: "Город",
                value: passport.city,
              ),
              _Item(
                name: "Адрес (ул., дом, кв.)",
                value: passport.address,
              ),
              _Item(
                name: "Медицинская справка / Дата окончания",
                value: passport.med_spravka_date,
              ),
              _Item(
                name: "Страховой полис / Дата окончания",
                value: passport.strah_date,
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
              Get.toNamed('/my_profile/documents');
            },
          ),
        )
      ],
    );
  }
}

class _Item extends StatelessWidget {
  _Item({Key? key, required this.name, this.value}) : super(key: key);
  final String name;
  final value;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondaryContainer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
              color: value != null
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).primaryColor),
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
                      color: Color(0xFF2674E9)),
                ),
              )
            : Text(
                "${value ?? "Необходимо заполнить"}",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: value != null
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).primaryColor),
              ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
