import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';

import '../../../widgets/images/brand_icon.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<UserState>(context).user;
    // bool isModer() {
    //   return user.role == 'moderator';
    // }
    GroupType item = Get.arguments;
    List<OptionType> listOptions =
        item.members.map((e) => OptionType(e.fullName, '')).toList();
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
            children: item.members
                .map((e) => Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Slidable(
                          endActionPane: ActionPane(
                              extentRatio: 0.1,
                              motion: ScrollMotion(),
                              children: [
                                BrandIcon(
                                  icon: 'decline',
                                  color: Colors.black,
                                  height: 18,
                                  width: 18,
                                  onTap: () {},
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Option(
                              text: e.fullName,
                              noArrow: true,
                            ),
                          )),
                    ))
                .toList()));
  }
}
