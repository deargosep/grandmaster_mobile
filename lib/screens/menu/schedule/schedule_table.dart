import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

class TableScheduleScreen extends StatelessWidget {
  TableScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PlaceType> places = Provider.of<PlacesState>(context).places;
    List<OptionType> list = places
        .map((e) => OptionType(e.name, '/schedule/groups', arguments: e))
        .toList();
    Map<String, List<String>> schedule = {
      "Понедельник": ['10:30', '12:30'],
      "Вторник": [],
      "Среда": ['10:30', '12:30'],
      "Четверг": ['10:30', '12:30'],
      "Пятница": [],
      "Суббота": ['10:30', '12:30'],
      "Воскресенье": ['10:30', '12:30']
    };
    return CustomScaffold(
        noTopPadding: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Расписание',
          icon: 'settings',
          iconOnTap: () {
            Get.toNamed('/schedule/edit');
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Schedule(schedule)
          ],
        ));
  }
}

class TimePill extends StatelessWidget {
  const TimePill(this.text, {Key? key, this.editMode = false})
      : super(key: key);
  final String text;
  final bool editMode;
  @override
  Widget build(BuildContext context) {
    if (editMode)
      return Input(
        height: 37,
        width: 75,
        defaultText: text,
        centerText: true,
        textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.secondary),
      );
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

class Schedule extends StatelessWidget {
  Schedule(this.schedule, {Key? key, this.editMode = false}) : super(key: key);
  final Map<String, List<String>> schedule;
  final bool editMode;
  final daysOfWeek = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье'
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 129,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: daysOfWeek
                  .map((e) => Container(
                      margin: EdgeInsets.only(bottom: 16), child: TimePill(e)))
                  .toList()),
        ),
        Container(
            width: 168,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: daysOfWeek
                  .map((e) => editMode
                      ? Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: schedule[e]!.isNotEmpty
                                ? [
                                    TimePill(schedule[e]![0], editMode: true),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TimePill(schedule[e]![1], editMode: true),
                                  ]
                                : [
                                    TimePill('', editMode: true),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TimePill('', editMode: true)
                                  ],
                          ),
                        )
                      : schedule[e]!.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  TimePill(schedule[e]![0]),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  TimePill(schedule[e]![1]),
                                ],
                              ),
                            )
                          : Container(
                              height: 37,
                              margin: EdgeInsets.only(bottom: 16),
                            ))
                  .toList(),
            ))
      ],
    );
  }
}
