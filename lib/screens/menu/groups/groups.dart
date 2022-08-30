import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../widgets/images/brand_icon.dart';

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
    User user = Provider.of<UserState>(context, listen: false).user;
    List listOfOptions = list
        .map((e) => Column(
              children: [
                Slidable(
                  key: Key(e.id.toString()),
                  endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: ScrollMotion(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: BrandIcon(
                            icon: 'settings',
                            color: Colors.black,
                            height: 18,
                            width: 18,
                            onTap: () {
                              Get.toNamed('/groups/add', arguments: e);
                            },
                          ),
                        ),
                      ]),
                  child: Option(
                      noArrow: true,
                      text: e.name,
                      onTap: () {
                        Get.toNamed('/group', arguments: e);
                      }),
                ),
                SizedBox(
                  height: 16,
                )
              ],
            ))
        .toList();
    return CustomScaffold(
        noPadding: false,
        noTopPadding: true,
        // scrollable: true,
        appBar: AppHeader(
          text: 'Группы спортсменов',
        ),
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        body: Provider.of<GroupsState>(context).isLoaded
            ? RefreshIndicator(
                onRefresh:
                    Provider.of<GroupsState>(context, listen: false).setGroups,
                child: ListView(
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
                    ...listOfOptions
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
