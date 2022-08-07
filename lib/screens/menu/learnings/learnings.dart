import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../state/user.dart';

class LearningsScreen extends StatelessWidget {
  const LearningsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    bool isModer() {
      return user.role == 'moderator';
    }

    return CustomScaffold(
        noPadding: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Учебные материалы',
          icon: isModer() ? 'plus' : null,
          iconOnTap: isModer()
              ? () {
                  Get.toNamed('/learnings/add');
                }
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              ...List.generate(
                  4,
                  (index) => Column(
                        children: [
                          LearningCard(),
                          SizedBox(
                            height: 16,
                          )
                        ],
                      ))
            ],
          ),
        ));
  }
}

class LearningCard extends StatelessWidget {
  const LearningCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).inputDecorationTheme.fillColor,
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Название учебного материала',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Описание учебного материала',
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondaryContainer),
          ),
        ],
      ),
    );
  }
}
