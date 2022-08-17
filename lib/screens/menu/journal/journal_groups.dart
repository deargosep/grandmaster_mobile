import 'package:flutter/material.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

class GroupsJournalScreen extends StatelessWidget {
  const GroupsJournalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GroupType> groups = Provider.of<GroupsState>(context).groups;
    List<OptionType> list = groups
        .map((e) => OptionType(e.name, '/journal/mark', arguments: e))
        .toList();
    return CustomScaffold(
        noTopPadding: true,
        appBar: AppHeader(
          text: 'Журнал посещений',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
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
