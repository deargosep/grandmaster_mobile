import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../widgets/brand_option.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context).userMeta;
    return CustomScaffold(
      noPadding: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              children: [
                Header(
                  withPadding: false,
                  withBack: false,
                  text: "Мой профиль",
                ),
                SizedBox(
                  height: 33,
                ),
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
                ListOfOptions(
                    //  TODO: this should be a global variable, not to being passed around widgets
                    user: user),
                SizedBox(
                  height: 32,
                ),
                InkWell(
                  onTap: () {
                    //  TODO: logout
                    Get.offAllNamed('/');
                  },
                  child: Text(
                    'Выйти из профиля',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListOfOptions extends StatelessWidget {
  const ListOfOptions({Key? key, required this.user}) : super(key: key);
  final Author user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Option(
          text: "Моя анкета",
          onTap: () {
            Get.toNamed('/profile/info', arguments: user);
          },
        ),
        SizedBox(
          height: 16,
        ),
        Option(
          text: "Мои события",
          onTap: () {
            Get.toNamed('/profile/events', arguments: user);
          },
        ),
        SizedBox(
          height: 16,
        ),
        Option(
          text: "Поддержка",
          onTap: () {
            Get.toNamed('/profile/support', arguments: user);
          },
        ),
        SizedBox(
          height: 32,
        ),
        BrandButton(
          text: 'Подписка',
          type: 'primary',
          textAlign: 'left',
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
        )
      ],
    );
  }
}
