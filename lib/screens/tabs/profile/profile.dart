import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:provider/provider.dart';

import '../../../widgets/header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context).userMeta;
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(
                0, 38 + MediaQuery.of(context).viewInsets.top, 0, 0),
            child: Column(children: [
              Header(
                text: 'Профили',
                withBack: false,
              ),
              SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListOfOptions(user: user),
              )
            ])));
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
            text: "Мой профиль",
            onTap: () {
              Get.toNamed('/profile/info', arguments: user);
            },
            type: 'primary'),
        SizedBox(
          height: 16,
        ),
        Option(
          text: "Иванов Иван Иванович",
          onTap: () {
            Get.toNamed('/profile/events', arguments: user);
          },
        ),
        SizedBox(
          height: 16,
        ),
        Option(
          text: "Иванов Иван Иванович",
          onTap: () {
            Get.toNamed('/profile/support', arguments: user);
          },
        ),
      ],
    );
  }
}
