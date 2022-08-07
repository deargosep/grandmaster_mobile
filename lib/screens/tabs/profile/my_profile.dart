import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../widgets/tabbar_switch.dart';
import '../../../widgets/top_tab.dart';
import 'child_profile.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

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
    var user = Provider.of<UserState>(context).user;
    bool hasAnyNulls() {
      var passport = user.passport;
      bool isNull = false;
      var list = [
        passport.sport_qualification,
        passport.weight,
        passport.height,
        passport.tech_qualification,
        passport.place_of_training,
        passport.trainer,
        passport.vedomstvo,
        passport.sport_school,
        passport.phoneNumber,
        passport.birthday,
        passport.fio,
        passport.address,
        passport.father_birthday,
        passport.father_email,
        passport.father_fio,
        passport.father_phoneNumber,
        passport.med_spravka_date,
        passport.mother_birthday,
        passport.city,
        passport.mother_email,
        passport.mother_fio,
        passport.mother_phoneNumber,
        passport.region,
        passport.school,
        passport.strah_date
      ];
      list.forEach((element) {
        if (element == null) isNull = true;
      });
      return isNull;
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

    return DefaultTabController(
      length: 2,
      child: CustomScaffold(
        noPadding: true,
        body: ListView(
          children: [
            SizedBox(
              height: 16,
            ),
            GestureDetector(
                onTap: () {
                  // TODO: more realistic dialog
                  getImage();
                },
                child:
                    Container(height: 136, width: 136, child: CircleAvatar())),
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
            Text(
              'Спортивная квалификация: текст',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontSize: 14),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Техническая квалификация: текст',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontSize: 14),
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
                      backgroundColor: hasAnyNulls() ? red : green,
                    )),
                SizedBox(
                  width: 8,
                ),
                Text(
                  hasAnyNulls() ? 'Не допущен' : 'Допущен',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondaryContainer,
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabsSwitch(
                controller: controller,
                children: [
                  TopTab(
                    text: 'Информация',
                  ),
                  TopTab(
                    text: 'Паспорт спортсмена',
                  )
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Container(
              height: controller.index == 0 ? 300 : 2062,
              child: TabBarView(
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
            )
          ],
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
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  value: passport.birthday,
                ),
                _Item(
                  name: "Телефон спортсмена",
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
                  name: "Тренер",
                  value: passport.trainer,
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
                  name: "Место учебы (город, школа)",
                  value: passport.school,
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
      ),
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
        Text(
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
