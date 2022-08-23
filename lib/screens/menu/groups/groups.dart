import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GroupsState>(context, listen: false).setGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<GroupType> list = Provider.of<GroupsState>(context).groups;
    List<OptionType> listOptions =
        list.map((e) => OptionType(e.name, '/group', arguments: e)).toList();
    var user = Provider.of<UserState>(context).user;
    return CustomScaffold(
        scrollable: true,
        appBar: AppHeader(
          text: 'Группы спортсменов',
        ),
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        body: Column(
          children: [
            user.role == 'trainer'
                ? Option(
                    text: 'Создать группу',
                    type: 'create',
                    noArrow: true,
                    onTap: () {
                      Get.toNamed('/groups/add');
                    },
                  )
                : Container(),
            user.role == 'trainer'
                ? SizedBox(
                    height: 16,
                  )
                : Container(),
            ListOfOptions(
              list: listOptions,
              noArrow: true,
            )
          ],
        ));
  }
}
