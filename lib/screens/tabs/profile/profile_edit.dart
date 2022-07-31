import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/input.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController birthday =
      TextEditingController(text: Get.arguments.birthday);
  @override
  Widget build(BuildContext context) {
    final Author user = Get.arguments;
    return CustomScaffold(
      appBar: AppHeader(
        text: "Редактирование анкеты",
      ),
      bottomNavigationBar: BottomPanel(
        child: BrandButton(
            onPressed: () {
              Get.back();
            },
            text: 'Применить'),
      ),
      noPadding: true,
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 91,
                      width: 91,
                      child: CircleAvatar(),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Дата регистрации: ${user.registration_date}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xFF6A7592)),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                ),
                Input(
                  defaultText: user.name,
                ),
                SizedBox(
                  height: 16,
                ),
                Input(
                  defaultText: user.gender,
                ),
                SizedBox(
                  height: 16,
                ),
                Input(
                  icon: 'calendar',
                  controller: birthday,
                  onTapCalendar: (value) {
                    birthday.text = value;
                  },
                  defaultText: user.birthday,
                ),
                SizedBox(
                  height: 16,
                ),
                Input(
                  defaultText: user.country,
                ),
                SizedBox(
                  height: 16,
                ),
                Input(
                  defaultText: user.city,
                ),
                SizedBox(
                  height: 16,
                ),
                Input(
                  expanded: true,
                  defaultText: user.description,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 81,
          )
        ],
      ),
    );
  }
}
