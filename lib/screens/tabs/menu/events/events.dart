import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '/utils/custom_scaffold.dart';
import '../../../../widgets/brand_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    var user = Provider.of<UserState>(context);
    return CustomScaffold(
      noPadding: true,
      bottomNavigationBar: BottomBarWrap(currentTab: 0),
      appBar: AppHeader(
        text: 'Мероприятия',
        icon: user.user.role == 'moderator' ? 'plus' : '',
        iconOnTap: () {
          Get.toNamed('/add_edit_article');
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(children: [
              // List
              Content(),
              SizedBox(
                height: 97,
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<EventsState>(context, listen: true).events;
    if (list.isNotEmpty) {
      return Column(
          children: list.map((item) {
        return BrandCard(
          item,
          type: 'events',
        );
      }).toList());
    }
    return Center(child: Text('Пока что событий нет'));
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white);
    const textStyleBold = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white);
    return Container(
      height: 76 + MediaQuery.of(context).viewPadding.top,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
          16, 16 + MediaQuery.of(context).viewPadding.top, 16, 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          color: Theme.of(context).primaryColor),
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/change_city');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'События в городе',
              style: textStyle,
            ),
            Text(
              Provider.of<UserState>(context, listen: true).user.city,
              style: textStyleBold,
            )
          ],
        ),
      ),
    );
  }
}
