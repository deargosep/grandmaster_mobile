import 'package:flutter/material.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
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
    List<GroupType> groups = Provider.of<GroupsState>(context).groups;
    List<OptionType> list = groups
        .map((e) => OptionType(e.name, '/schedule/table', arguments: e))
        .toList();
    return CustomScaffold(
        noTopPadding: true,
        scrollable: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Расписание',
        ),
        body: Column(
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
            ListOfOptions(
              list: list,
              noArrow: true,
            )
          ],
        ));
  }
}
