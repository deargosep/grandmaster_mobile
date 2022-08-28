import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/state/visit_log.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../utils/dio.dart';

class GroupsJournalScreen extends StatefulWidget {
  const GroupsJournalScreen({Key? key}) : super(key: key);

  @override
  State<GroupsJournalScreen> createState() => _GroupsJournalScreenState();
}

class _GroupsJournalScreenState extends State<GroupsJournalScreen> {
  var arguments = Get.arguments;
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
    List<Column> list = groups
        .map((e) => Column(
              children: [
                Option(
                    text: e.name,
                    onTap: () {
                      var groupId = e.id;
                      var placeId = arguments;
                      createDio(
                              showSnackbar: false,
                              errHandler: (err, handler) {
                                if (err.response?.statusCode == 400) {
                                  Get.defaultDialog(
                                      title: 'Ошибка',
                                      content:
                                          Text("Журнал ещё нельзя создать!"));
                                }
                              })
                          .get(
                              '/visit_log/?gym=${placeId}&sport_group=${groupId}')
                          .then((value) {
                        // print(value);
                        Provider.of<VisitLogState>(context, listen: false)
                            .setVisitLog(placeId, groupId);
                        Get.toNamed('/journal/mark', arguments: {
                          "placeId": placeId,
                          "groupId": groupId,
                        });
                      });
                    }),
                SizedBox(
                  height: 16,
                )
              ],
            ))
        .toList();
    return CustomScaffold(
        noTopPadding: true,
        noPadding: false,
        appBar: AppHeader(
          text: 'Журнал посещений',
        ),
        body: list.isNotEmpty
            ? ListView(
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
                  ...list
                ],
              )
            : Text('Нет групп'));
  }
}
