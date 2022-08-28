import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
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
  bool isLoading = true;
  late GroupType group;

  bool hasEqual(List<User> list, User item) {
    return list.firstWhereOrNull((element) => element.id == item.id) != null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<MinimalUser> sportsmens =
          await Provider.of<GroupsState>(context, listen: false)
              .setSportsmens();
      GroupType group = Get.arguments;
      setState(() {
        checkboxes = {
          for (var v in sportsmens)
            '${v.id}_${v.fullName}': group.members
                        .firstWhereOrNull((element) => element.id == v.id) !=
                    null
                ? true
                : false,
        };
      });
      setState(() {
        isLoading = false;
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

    List<MinimalUser> sportsmens =
        Provider.of<GroupsState>(context, listen: false).sportsmens;
    GroupType item = Get.arguments;
    // List<User> users = Provider.of<UserState>(context).list;
    return CustomScaffold(
        // scrollable: true,
        noHorPadding: true,
        noVerPadding: true,
        appBar: AppHeader(
          text: item.name,
        ),
        bottomNavigationBar: BottomPanel(
            child: BrandButton(
          text: 'Продолжить',
          onPressed: () {
            // TODO: check
            List<int> checked = checkboxes!.entries
                .where((element) => element.value)
                .map((e) => int.parse(e.key.split('_')[0]))
                .toList();
            createDio()
                .patch('/sport_groups/${item.id}/fetch_members/', data: checked)
                .then(
              (value) {
                Provider.of<GroupsState>(context, listen: false).setGroups();
                Get.back();
              },
            );
          },
        )),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
