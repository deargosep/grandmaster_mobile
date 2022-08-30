import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/profile/my_profile.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/custom_scaffold.dart';
import '../../../widgets/header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context, listen: false).user;
    if (user.children.isEmpty) {
      return MyProfileScreen();
    }
    List<OptionType> optionList = [
      OptionType('Мой профиль', '/my_profile',
          type: 'primary', arguments: user),
      ...Provider.of<UserState>(context, listen: false)
          .user
          .children
          .map((e) => OptionType(e.fullName, '/child_profile', arguments: e)),
    ];
    return CustomScaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(
                0, 38 + MediaQuery.of(context).viewInsets.top, 0, 0),
            child: Column(children: [
              Header(
                text: 'Профили',
                withBack: false,
                icon: 'logout',
                iconOnTap: () {
                  SharedPreferences.getInstance().then((value) =>
                      value.clear().then((value) => Get.offAllNamed('/')));
                },
              ),
              SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListOfOptions(list: optionList),
              )
            ])));
  }
}

class Info extends StatelessWidget {
  Info({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondaryContainer;
    return ListView(
      shrinkWrap: true,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Дата рождения',
          style: TextStyle(color: color),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          user.birthday != null
              ? DateFormat('dd.MM.y').format(user.birthday!)
              : '',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'Номер телефона',
          style: TextStyle(color: color),
        ),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: user.passport.phoneNumber != null
              ? () {
                  launchUrlString('tel://${user.passport.phoneNumber}');
                }
              : null,
          child: Text(
            "${user.passport.phoneNumber ?? "Нет"}",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: user.passport.phoneNumber != null
                    ? Color(0xFF2674E9)
                    : Theme.of(context).colorScheme.secondary),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'Страна',
          style: TextStyle(color: color),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          user.country ?? "Нет",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'Город',
          style: TextStyle(color: color),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          user.city ?? "Нет",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary),
        ),
      ],
    );
  }
}
