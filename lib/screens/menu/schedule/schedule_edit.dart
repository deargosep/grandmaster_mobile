import 'package:flutter/material.dart';
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

import 'schedule_table.dart';

class EditScheduleScreen extends StatelessWidget {
  EditScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PlaceType> places = Provider.of<Places>(context).places;
    List<OptionType> list = places
        .map((e) => OptionType(e.name, '/schedule/groups', arguments: e))
        .toList();
    Map<String, List<String>> schedule = {
      "Понедельник": ['10:30', '10:30'],
      "Вторник": [],
      "Среда": ['10:30', '12:30'],
      "Четверг": ['10:30', '12:30'],
      "Пятница": [],
      "Суббота": ['10:30', '12:30'],
      "Воскресенье": ['10:30', '12:30']
    };
    return CustomScaffold(
        noTopPadding: true,
        bottomNavigationBar: BottomPanel(
            withShadow: false, child: BrandButton(text: 'Сохранить')),
        appBar: AppHeader(
          text: 'Редактирование',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Schedule(schedule, editMode: true)
          ],
        ));
  }
}
