import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

import '../../../widgets/header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<OptionType> optionList = [
      OptionType('Мой профиль', '/my_profile', type: 'primary'),
      ...Provider.of<UserState>(context, listen: false)
          .user
          .children
          .map((e) => OptionType(e.fullName, '/child_profile', arguments: e)),
    ];
    var user = Provider.of<UserState>(context).user;
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
                child: ListOfOptions(list: optionList),
              )
            ])));
  }
}

class _ListOfOptions extends StatelessWidget {
  const _ListOfOptions({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Option(
            text: "Мой профиль",
            onTap: () {
              Get.toNamed('/my_profile', arguments: user);
            },
            type: 'primary'),
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: Provider.of<UserState>(context).user.children.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Option(
                    text: Provider.of<UserState>(context)
                        .user
                        .children[index]
                        .fullName,
                    onTap: () {
                      Get.toNamed('/child_profile',
                          arguments:
                              Provider.of<UserState>(context, listen: false)
                                  .user
                                  .children[index]);
                    },
                  ),
                ],
              );
            }),
      ],
    );
  }
}
