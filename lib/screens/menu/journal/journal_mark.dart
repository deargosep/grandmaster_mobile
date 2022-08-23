import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/checkboxes_list.dart';
import 'package:grandmaster/widgets/header.dart';

import '../../../state/user.dart';

class MarkJournalScreen extends StatefulWidget {
  const MarkJournalScreen({Key? key}) : super(key: key);

  @override
  State<MarkJournalScreen> createState() => _MarkJournalScreenState();
}

class _MarkJournalScreenState extends State<MarkJournalScreen> {
  Map<String, bool>? checkboxes;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // List<User> users = Provider.of<UserState>(context, listen: false).list;
      List<MinimalUser> groupUsers = Get.arguments.members;
      print(groupUsers);
      setState(() {
        checkboxes = {
          for (var v in groupUsers) '${v.id}_${v.full_name}': false
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<GroupType> groups = Provider.of<GroupsState>(context).groups;
    // List<OptionType> list = groups
    //     .map((e) => OptionType(e.name, '/schedule/table', arguments: e))
    //     .toList();
    void changeCheckbox(newState) {
      setState(() {
        checkboxes = newState;
      });
    }

    return CustomScaffold(
        noTopPadding: true,
        scrollable: true,
        appBar: AppHeader(
          text: 'Журнал посещений',
        ),
        bottomNavigationBar: BottomPanel(
          withShadow: false,
          child: BrandButton(
            text: 'Сохранить',
          ),
        ),
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Pill('22.06.2022'),
                SizedBox(
                  width: 16,
                ),
                Pill('10:30'),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Отметьте присутствующих',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            SizedBox(
              height: 32,
            ),
            CheckboxesList(
              changeCheckbox: changeCheckbox,
              checkboxes: checkboxes,
            )
          ],
        ));
  }
}

class Pill extends StatelessWidget {
  const Pill(this.text, {Key? key}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 37,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }
}
