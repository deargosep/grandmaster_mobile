import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/state/schedule.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../utils/bottombar_wrap.dart';

class GroupsScheduleScreen extends StatefulWidget {
  const GroupsScheduleScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScheduleScreen> createState() => _GroupsScheduleScreenState();
}

class _GroupsScheduleScreenState extends State<GroupsScheduleScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GroupsState>(context, listen: false).setGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    var placeId = Get.arguments;
    List<GroupType> groups = Provider.of<GroupsState>(context).groups;
    List<Column> list = groups
        .map((e) => Column(
              children: [
                Option(
                  text: e.id.toString(),
                  onTap: () {
                    Provider.of<ScheduleState>(context, listen: false)
                        .setSchedule(Get.arguments, e.id, showSnackbar: false,
                            errHandler: (err, handler) {
                      if (err.response?.statusCode == 404) {
                        Get.toNamed('/schedule/edit', arguments: {
                          "placeId": placeId,
                          "groupId": e.id,
                          "createMode": true
                        });
                      }
                    }).then((value) {
                      Get.toNamed('/schedule/table',
                          arguments: {"placeId": placeId, "groupId": e.id});
                    });
                  },
                ),
                SizedBox(
                  height: 16,
                )
              ],
            ))
        .toList();
    return CustomScaffold(
        noTopPadding: true,
        // scrollable: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Расписание',
        ),
        body: ListView(
          children: [
            Text(
              'Выберите группу',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            SizedBox(
              height: 32,
            ),
            ...list
          ],
        ));
  }
}
