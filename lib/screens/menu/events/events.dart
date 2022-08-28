import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '/utils/custom_scaffold.dart';
import '../../../../widgets/brand_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EventsState>(context, listen: false).setEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    User user = Provider.of<UserState>(context).user;
    bool isLoaded = Provider.of<EventsState>(context).isLoaded;
    return CustomScaffold(
      noPadding: true,
      // scrollable: true,
      bottomNavigationBar: BottomBarWrap(currentTab: 0),
      appBar: AppHeader(
        text: 'Мероприятия',
        icon: user.role == 'moderator' ? 'plus' : '',
        iconOnTap: () {
          Get.toNamed('/events/add');
        },
      ),
      body: isLoaded ? Content() : Center(child: CircularProgressIndicator()),
    );
  }
}

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    var list = Provider.of<EventsState>(context, listen: true).events;
    if (list.isNotEmpty) {
      return ListView(
          children: list.map((item) {
        return BrandCard(
          item,
          // TODO
          () {
            createDio()
                .patch('/events/${item.id}/',
                    data: FormData.fromMap({"hidden": 'true'}))
                .then((value) {
              Provider.of<EventsState>(context, listen: false).setEvents();
            });
          },
          () {
            createDio().delete('/events/${item.id}/').then((value) {
              Provider.of<EventsState>(context, listen: false).setEvents();
            });
          },
          type: 'events',
        );
      }).toList());
    }
    return Center(child: Text('Нет мероприятий'));
  }
}
