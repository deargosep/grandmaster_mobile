import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GroupType> list = Provider.of<GroupsState>(context).groups;
    List<OptionType> listOptions =
        list.map((e) => OptionType(e.name, '/group', arguments: e)).toList();
    return CustomScaffold(
        scrollable: true,
        appBar: AppHeader(
          text: 'Группы спортсменов',
        ),
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        body: Column(
          children: [
            Option(
              text: 'Создать группу',
              type: 'create',
              noArrow: true,
              onTap: (){
                Get.toNamed('/groups/add');
              },
            ),
            SizedBox(height: 16,),
            ListOfOptions(
              list: listOptions,
              noArrow: true,
            )
          ],
        ));
  }
}
