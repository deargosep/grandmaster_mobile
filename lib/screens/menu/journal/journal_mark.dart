import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/state/visit_log.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/checkboxes_list.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarkJournalScreen extends StatefulWidget {
  const MarkJournalScreen({Key? key}) : super(key: key);

  @override
  State<MarkJournalScreen> createState() => _MarkJournalScreenState();
}

class _MarkJournalScreenState extends State<MarkJournalScreen> {
  Map<String, bool>? checkboxes;
  var arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    Provider.of<VisitLogState>(context, listen: false)
        .setVisitLog(arguments["placeId"], arguments["groupId"]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // var members = [];
      // createDio()
      //     .get('/visit_log/?gym=${placeId}&sport_group=${groupId}')
      //     .then((value) {
      //   print(value);
      // });
      // Provider.of<VisitLogState>(context).setVisitLog(placeId, groupId)
      createDio().get('/sport_groups/${arguments["groupId"]}/').then((value) {
        var users = value.data["members"]
            .map((e) => MinimalUser(fullName: e["full_name"], id: e["id"]));
        List<MinimalUser> attending = [
          ...Provider.of<VisitLogState>(context, listen: false)
              .visitLog
              .attending
              .map((e) => MinimalUser(fullName: e["full_name"], id: e["id"]))
              .toList()
        ];
        // print(groupUsers);
        setState(() {
          checkboxes = {
            for (var v in users)
              '${v.id}_${v.fullName}':
                  attending.firstWhereOrNull((element) => element.id == v.id) !=
                      null
          };
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    VisitLogType visitLog = Provider.of<VisitLogState>(context).visitLog;
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
        noPadding: false,
        appBar: AppHeader(
          text: 'Журнал посещений',
        ),
        bottomNavigationBar: BottomPanel(
          withShadow: false,
          child: BrandButton(
            text: 'Сохранить',
            onPressed: () {
              createDio().post(
                  '/visit_log/?gym=${visitLog.gym}&sport_group=${visitLog.group}',
                  data: {
                    "attending": checkboxes?.entries
                        .where((element) => element.value)
                        .map((e) => e.key.split('_')[0])
                        .toList()
                  }).then((value) {
                Get.back();
                Get.back();
              });
            },
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
                Pill(DateFormat('dd.MM.y').format(visitLog.datetime)),
                SizedBox(
                  width: 16,
                ),
                Pill(visitLog.start_time),
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
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 37,
      width: 94,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w500,
            fontSize: 14),
      ),
    );
  }
}
