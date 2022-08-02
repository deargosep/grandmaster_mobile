import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/widgets/event_card.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:provider/provider.dart';

import '../../../utils/custom_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    var user = Provider.of<UserState>(context);
    return CustomScaffold(
      noPadding: true,
      appBar: AppHeader(
        text: 'Новости',
        withBack: false,
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
              Content()
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
    var list = Provider.of<Articles>(context, listen: true).news;
    var user = Provider.of<UserState>(context);
    if (list.isNotEmpty) {
      return Column(
          children: list.map((item) {
        return Slidable(
          enabled: user.user.role == 'moderator',
          endActionPane:
              ActionPane(extentRatio: 0.3, motion: ScrollMotion(), children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BrandIcon(
                      icon: 'settings',
                      color: Colors.black,
                      height: 18,
                      width: 18,
                      onTap: () {
                        Get.toNamed('/add_edit_article', arguments: item.id);
                      },
                    ),
                    BrandIcon(
                      icon: 'no_view',
                      color: Colors.black,
                      height: 18,
                      width: 18,
                    ),
                    BrandIcon(
                      icon: 'x',
                      color: Colors.black,
                      height: 18,
                      width: 18,
                    ),
                    SizedBox(
                      width: 0,
                    )
                  ],
                ),
              ),
            ),
          ]),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xFFF3F3F3), width: 2))),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: EventCard(item: item),
            ),
          ),
        );
      }).toList());
      return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: EventCard(item: list[index]),
            );
          });
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
