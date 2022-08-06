import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/top_tab.dart';

import '../state/user.dart';
import '../widgets/tabbar_switch.dart';

class ProfileOtherScreen extends StatefulWidget {
  ProfileOtherScreen({Key? key}) : super(key: key);

  @override
  State<ProfileOtherScreen> createState() => _ProfileOtherScreenState();
}

class _ProfileOtherScreenState extends State<ProfileOtherScreen>
    with TickerProviderStateMixin {
  final User author = Get.arguments;
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
              author.name,
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
            Expanded(child: TabBarView(children: [])),
          ],
        ),
      ),
    );
  }
}
