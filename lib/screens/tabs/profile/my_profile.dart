import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/profile/profile.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

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
