import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../utils/dio.dart';
import '../../../widgets/images/brand_icon.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  GroupType item = Get.arguments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<GroupsState>(context, listen: false).setGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    void removeMember(int id) {
      createDio().patch('/sport_groups/${item.id}/remove_member/',
          data: {"id": id}).then((value) {
        Provider.of<GroupsState>(context, listen: false).setGroups();
        // var newItem = GroupType(
        //     id: item.id,
        //     name: item.name,
        //     minAge: item.minAge,
        //     maxAge: item.maxAge,
        //     members: value.data.members.map(
        //         (e) => MinimalUser(full_name: e["full_name"], id: e["id"])));
        // setState(() {
        //   item = newItem;
        // });
      });
    }

    return CustomScaffold(
        scrollable: true,
        noHorPadding: true,
        appBar: AppHeader(
          text: item.name,
          icon: 'plus',
          iconOnTap: () {
            Get.toNamed('/group/manage', arguments: item);
          },
        ),
        body: Column(
            children: context
                .watch<GroupsState>()
                .groups
                .firstWhere((element) => item.id == element.id)
                .members
                .map((e) => Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                              extentRatio: 0.1,
                              motion: ScrollMotion(),
                              children: [
                                BrandIcon(
                                  icon: 'decline',
                                  color: Colors.black,
                                  height: 18,
                                  width: 18,
                                  onTap: () {
                                    removeMember(e.id);
                                  },
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Option(
                              text: e.full_name,
                              noArrow: true,
                            ),
                          )),
                    ))
                .toList()));
  }
}
