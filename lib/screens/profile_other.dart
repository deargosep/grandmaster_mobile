import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/top_tab.dart';
import 'package:provider/provider.dart';

import '../state/events.dart';
import '../widgets/tabbar_switch.dart';

class ProfileOtherScreen extends StatefulWidget {
  ProfileOtherScreen({Key? key}) : super(key: key);

  @override
  State<ProfileOtherScreen> createState() => _ProfileOtherScreenState();
}

class _ProfileOtherScreenState extends State<ProfileOtherScreen>
    with TickerProviderStateMixin {
  final Author author = Get.arguments;
  late TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return CustomScaffold(
      padding: EdgeInsets.fromLTRB(
          20, 40 + MediaQuery.of(context).viewInsets.top, 20, 0),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: BrandIcon(icon: 'back_arrow')),
            Container(
              height: 114,
              width: 114,
              child: CircleAvatar(),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              author.username,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 24,
            ),
            TabsSwitch(
              children: [
                TopTab(
                  text: 'Информация',
                ),
                TopTab(
                  text: 'История событий',
                )
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Expanded(
                child: TabBarView(children: [
              Info(
                author: author,
              ),
              History(
                items: Provider.of<Articles>(context)
                    .events
                    .where((e) => e.author.username == author.username)
                    .toList(),
              )
            ])),
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({Key? key, required this.author}) : super(key: key);
  final Author author;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Имя',
          style: TextStyle(color: Color(0xFF6A7592)),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          author.name,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'Возраст',
          style: TextStyle(color: Color(0xFF6A7592)),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          author.age.toString(),
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
          style: TextStyle(color: Color(0xFF6A7592)),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          author.country,
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
          style: TextStyle(color: Color(0xFF6A7592)),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          author.city,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'О себе',
          style: TextStyle(color: Color(0xFF6A7592)),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          author.description,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary),
        ),
      ],
    );
  }
}

class History extends StatelessWidget {
  const History({Key? key, required this.items}) : super(key: key);
  final List<ArticleType> items;
  @override
  Widget build(BuildContext context) {
    //TODO
    return ListView(
      children: [
        Text(
          'Активные',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          'Завершенные',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
