import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/schedule.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:provider/provider.dart';

class TableScheduleScreen extends StatefulWidget {
  TableScheduleScreen({Key? key}) : super(key: key);

  @override
  State<TableScheduleScreen> createState() => _TableScheduleScreenState();
}

class _TableScheduleScreenState extends State<TableScheduleScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // var placeId = Get.arguments["placeId"];
      // var groupId = Get.arguments["groupId"];
      // print('$placeId $groupId');
      // Provider.of<ScheduleState>(context, listen: false)
      //     .setSchedule(placeId, groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, List<String>> schedule = {
    //   "Понедельник": ['10:30', '12:30'],
    //   "Вторник": [],
    //   "Среда": ['10:30', '12:30'],
    //   "Четверг": ['10:30', '12:30'],
    //   "Пятница": [],
    //   "Суббота": ['10:30', '12:30'],
    //   "Воскресенье": ['10:30', '12:30']
    // };
    ScheduleType schedule = Provider.of<ScheduleState>(context).schedule;
    return CustomScaffold(
        noTopPadding: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Расписание',
          icon: Provider.of<UserState>(context).user.role == 'trainer'
              ? 'settings'
              : '',
          iconOnTap: Provider.of<UserState>(context).user.role == 'trainer'
              ? () {
                  Get.toNamed('/schedule/edit');
                }
              : null,
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

class Schedule extends StatelessWidget {
  Schedule(this.schedule,
      {Key? key,
      this.editMode = false,
      this.monday1,
      this.monday2,
      this.tuesday1,
      this.tuesday2,
      this.wednesday1,
      this.wednesday2,
      this.thursday1,
      this.thursday2,
      this.friday1,
      this.friday2,
      this.saturday1,
      this.saturday2,
      this.sunday1,
      this.sunday2})
      : super(key: key);
  final ScheduleType schedule;
  final bool editMode;
  TextEditingController? monday1 = TextEditingController();
  TextEditingController? monday2 = TextEditingController();
  TextEditingController? tuesday1 = TextEditingController();
  TextEditingController? tuesday2 = TextEditingController();
  TextEditingController? wednesday1 = TextEditingController();
  TextEditingController? wednesday2 = TextEditingController();
  TextEditingController? thursday1 = TextEditingController();
  TextEditingController? thursday2 = TextEditingController();
  TextEditingController? friday1 = TextEditingController();
  TextEditingController? friday2 = TextEditingController();
  TextEditingController? saturday1 = TextEditingController();
  TextEditingController? saturday2 = TextEditingController();
  TextEditingController? sunday1 = TextEditingController();
  TextEditingController? sunday2 = TextEditingController();

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
    TextEditingController? getController(String day, int index) {
      // var list = [monday1, monday2, tuesday1, tuesday2, wednesday1, wednesday2, thursday1, thursday2, friday1, friday2, saturday1, saturday2, sunday1, sunday2];
      var list = {
        "monday": [monday1, monday2],
        "tuesday": [tuesday1, tuesday2],
        "wednesday": [wednesday1, wednesday2],
        "thursday": [thursday1, thursday2],
        "friday": [friday1, friday2],
        "saturday": [saturday1, saturday2],
        "sunday": [sunday1, sunday2],
      };
      return list[day]![index];
    }

    String getDay(String day) {
      switch (day) {
        case 'monday':
          return daysOfWeek[0];
        case 'tuesday':
          return daysOfWeek[1];
        case 'wednesday':
          return daysOfWeek[2];
        case 'thursday':
          return daysOfWeek[3];
        case 'friday':
          return daysOfWeek[4];
        case 'saturday':
          return daysOfWeek[5];
        case 'sunday':
          return daysOfWeek[6];
        default:
          return '';
      }
    }

    String getDayReverse(String day) {
      switch (day) {
        case 'Понедельник':
          return 'monday';
        case 'Вторник':
          return 'tuesday';
        case 'Среда':
          return 'friday';
        case 'Четверг':
          return 'thursday';
        case 'Пятница':
          return 'friday';
        case 'Суббота':
          return 'saturday';
        case 'Воскресенье':
          return 'sunday';
        default:
          return '';
      }
    }

    print(schedule.days);
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
                            children: schedule
                                    .days[getDayReverse(e)]!.isNotEmpty
                                ? [
                                    TimePill(
                                      schedule.days[getDayReverse(e)]![0]!,
                                      editMode: true,
                                      controller:
                                          getController(getDayReverse(e), 0),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TimePill(
                                        schedule.days[getDayReverse(e)]![1]!,
                                        controller:
                                            getController(getDayReverse(e), 1),
                                        editMode: true),
                                  ]
                                : [
                                    TimePill(
                                      '',
                                      editMode: true,
                                      controller:
                                          getController(getDayReverse(e), 0),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TimePill(
                                      '',
                                      editMode: true,
                                      controller:
                                          getController(getDayReverse(e), 1),
                                    )
                                  ],
                          ),
                        )
                      : schedule.days[getDayReverse(e)]!.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  TimePill(
                                      schedule.days[getDayReverse(e)]![0]!),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  TimePill(
                                      schedule.days[getDayReverse(e)]![1]!),
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

class TimePill extends StatelessWidget {
  const TimePill(this.text, {Key? key, this.editMode = false, this.controller})
      : super(key: key);
  final String text;
  final bool editMode;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    if (editMode)
      return Input(
        height: 37,
        width: 76,
        controller: controller,
        validator: (text) => null,
        defaultText: text,
        centerText: true,
        maxLength: 5,
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

String getDay(String day) {
  switch (day) {
    case 'monday':
      return 'Пн';
    case 'tuesday':
      return 'Вт';
    case 'wednesday':
      return 'Ср';
    case 'thursday':
      return "Чт";
    case 'friday':
      return "Пт";
    case 'saturday':
      return "Сб";
    case 'sunday':
      return "Вс";
    default:
      return '';
  }
}

String getDayReverse(String day) {
  switch (day) {
    case 'Понедельник':
      return 'monday';
    case 'Вторник':
      return 'tuesday';
    case 'Среда':
      return 'friday';
    case 'Четверг':
      return 'thursday';
    case 'Пятница':
      return 'friday';
    case 'Суббота':
      return 'saturday';
    case 'Воскресенье':
      return 'sunday';
    default:
      return '';
  }
}
