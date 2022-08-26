import 'package:flutter/material.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:grandmaster/widgets/select_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LogJournalScreen extends StatefulWidget {
  LogJournalScreen({Key? key}) : super(key: key);

  @override
  State<LogJournalScreen> createState() => _LogJournalScreenState();
}

class _LogJournalScreenState extends State<LogJournalScreen> {
  String group = 'none';
  String groupId = '0';
  TextEditingController dateStart = TextEditingController(text: '25.07.2022');
  TextEditingController timeStart = TextEditingController(text: '10:00');
  TextEditingController dateEnd = TextEditingController(text: '25.09.2022');
  TextEditingController timeEnd = TextEditingController(text: '13:00');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GroupsState>(context, listen: false).setGroups();
  }

  @override
  Widget build(BuildContext context) {
    List<GroupType> groups = Provider.of<GroupsState>(context).groups;
    List items = groups.map((e) => '${e.id}_${e.name}').toList();
    void onChange(String value) {
      setState(() {
        group = value;
        groupId = value.split('_')[0];
      });
    }

    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      bottomNavigationBar: BottomPanel(
        withShadow: false,
        child: BrandButton(
          text: 'Сформировать отчет',
          onPressed: () {
            dynamic datetimestart = DateFormat('d.MM.y_H:m')
                .parse('${dateStart.text}_${timeStart.text}');
            dynamic datetimeend = DateFormat('d.MM.y_H:m')
                .parse('${dateEnd.text}_${timeEnd.text}');
            datetimestart = DateFormat('y-MM-dT')
                .add_Hm()
                .format(datetimestart)
                .replaceAll(' ', '');
            datetimeend = DateFormat('y-MM-dT')
                .add_Hm()
                .format(datetimeend)
                .replaceAll(' ', '');
            // '${dateEnd.text.replaceAll('.', '-')}T${timeEnd.text}';
            print(groupId);
            print(datetimestart);
            print(datetimeend);
            createDio(errHandler: (err, handler) {
              print(err.requestOptions.path);
              print(err.requestOptions.queryParameters);
            }).get('/visit_log/report/', queryParameters: {
              "sport_group": groupId,
              "start_datetime": datetimestart,
              'end_datetime': datetimeend
            }).then((value) => launchUrl(Uri.parse(value.data["url"]),
                mode: LaunchMode.externalApplication));
            // Get.toNamed('/success', arguments: 'Отчет успешно сформирован');
          },
        ),
      ),
      appBar: AppHeader(
        text: 'Отчет',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
            ),
            SelectList(onChange: onChange, value: group, items: items),
            SizedBox(
              height: 32,
            ),
            Text(
              'Период от:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 24,
            ),
            InputDate(
              label: 'Дата',
            ),
            SizedBox(
              height: 16,
            ),
            Input(
              label: 'Время',
              maxLength: 5,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Период до:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 24,
            ),
            InputDate(
              label: 'Дата',
            ),
            SizedBox(
              height: 16,
            ),
            Input(
              label: 'Время',
              maxLength: 5,
            ),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
