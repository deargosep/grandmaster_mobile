import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/news.dart';

import '../../../utils/bottombar_wrap.dart';
import '../../../widgets/images/brand_icon.dart';

class ChildProfileScreen extends StatelessWidget {
  const ChildProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Get.arguments;
    return Scaffold(
        bottomNavigationBar: BottomBarWrap(
          currentTab: 3,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 32, left: 0, right: 0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 28,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: BrandIcon(
                    icon: 'back_arrow',
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Positioned(
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Container(height: 136, width: 136, child: CircleAvatar()),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        user.fullName,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Divider(
                        height: 0,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Info(
                          user: user,
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}

class Info extends StatelessWidget {
  Info({Key? key, required this.user}) : super(key: key);
  final User user;
  final color = Color(0xFF927474);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Дата рождения',
            style: TextStyle(color: color),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            user.birthday,
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
          Text(
            "${user.phoneNumber ?? "Нет"}",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary),
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
            user.country,
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
            user.city,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
