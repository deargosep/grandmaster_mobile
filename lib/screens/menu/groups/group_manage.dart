import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/checkboxes_list.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

class GroupManageScreen extends StatefulWidget {
  const GroupManageScreen({Key? key}) : super(key: key);

  @override
  State<GroupManageScreen> createState() => _GroupManageScreenState();
}

class _GroupManageScreenState extends State<GroupManageScreen> {
  Map<String, bool>? checkboxes;

  bool hasEqual(List<User> list, User item) {
    return list.firstWhereOrNull((element) => element.id == item.id) != null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<User> users = Provider.of<UserState>(context, listen: false).list;
      List<User> groupUsers = Get.arguments.members;
      print(groupUsers);
      setState(() {
        checkboxes = {for (var v in users) v.fullName: hasEqual(groupUsers, v)};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void changeCheckboxesState(newState) {
      setState(() {
        checkboxes = newState;
      });
    }

    GroupType item = Get.arguments;
    List<User> users = Provider.of<UserState>(context).list;
    return CustomScaffold(
        scrollable: true,
        noHorPadding: true,
        noTopPadding: true,
        appBar: AppHeader(
          text: item.name,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Добавьте участников группы',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CheckboxesList(
                changeCheckbox: changeCheckboxesState,
                checkboxes: checkboxes,
              ))
        ]));
  }
}
