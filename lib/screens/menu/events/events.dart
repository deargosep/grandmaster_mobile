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
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    var list = Provider.of<EventsState>(context, listen: true).events;
    if (list.isNotEmpty) {
      return ListView.builder(
          itemCount: list.length,
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: getDeviceType() == 'tablet' ? 2 : 1,
          //     crossAxisSpacing: 0.0,
          //     mainAxisSpacing: 0.0,
          //     childAspectRatio: getDeviceType() == 'tablet'
          //         ? currentOrientation == Orientation.portrait
          //             ? 0.9
          //             : 1.3
          //         : 1.15),
          itemBuilder: ((context, index) {
            return BrandCard(
              list[index],
              // TODO
              () {
                createDio()
                    .patch('/events/${list[index].id}/',
                        data: FormData.fromMap({"hidden": 'true'}))
                    .then((value) {
                  Provider.of<EventsState>(context, listen: false).setEvents();
                });
              },
              () {
                createDio().delete('/events/${list[index].id}/').then((value) {
                  Provider.of<EventsState>(context, listen: false).setEvents();
                });
              },
              type: 'events',
            );
          }));
    }
    return Center(child: Text('Нет мероприятий'));
  }
}
