import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:grandmaster/widgets/select_list.dart';
import 'package:provider/provider.dart';

class LogJournalScreen extends StatefulWidget {
  LogJournalScreen({Key? key}) : super(key: key);

  @override
  State<LogJournalScreen> createState() => _LogJournalScreenState();
}

class _LogJournalScreenState extends State<LogJournalScreen> {
  String group = 'none';

  @override
  Widget build(BuildContext context) {
    List<GroupType> groups = Provider.of<GroupsState>(context).groups;
    List items = groups.map((e) => e.name).toList();
    void onChange(value) {
      setState(() {
        group = value;
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
            Get.toNamed('/success', arguments: 'Отчет успешно сформирован');
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
            Input(
              label: 'Дата',
            ),
            SizedBox(
              height: 16,
            ),
            Input(
              label: 'Время',
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
            Input(
              label: 'Дата',
            ),
            SizedBox(
              height: 16,
            ),
            Input(
              label: 'Время',
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
