import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/schedule.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:provider/provider.dart';

class TableScheduleScreen extends StatefulWidget {
  TableScheduleScreen({Key? key}) : super(key: key);

  @override
  State<TableScheduleScreen> createState() => _TableScheduleScreenState();
}

class _TableScheduleScreenState extends State<TableScheduleScreen> {
  bool isLoaded = true;
  var placeId = Get.arguments["placeId"];
  var groupId = Get.arguments["groupId"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      placeId = Get.arguments["placeId"];
      groupId = Get.arguments["groupId"];
      // print('$placeId $groupId');
      Provider.of<ScheduleState>(context, listen: false)
          .setSchedule(placeId, groupId);
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
        noPadding: false,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Расписание',
          icon: Provider.of<UserState>(context).user.role == 'trainer'
              ? 'settings'
              : '',
          iconOnTap: Provider.of<UserState>(context).user.role == 'trainer'
              ? () {
                  Get.toNamed('/schedule/edit', arguments: {
                    "placeId": schedule.gym,
                    "groupId": schedule.group,
                    "createMode": false
                  });
                }
              : null,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Schedule(schedule),
            Spacer(),
            BrandButton(
              isLoaded: isLoaded,
              text: 'Очистить',
              onPressed: () {
                if (mounted)
                  setState(() {
                    isLoaded = false;
                  });
                createDio(errHandler: (err, handler) {
                  if (mounted)
                    setState(() {
                      isLoaded = true;
                    });
                }).delete('/schedule/', data: {
                  "gym": placeId.toString(),
                  "sport_group": groupId.toString(),
                }).then((value) {
                  if (mounted)
                    setState(() {
                      isLoaded = true;
                    });
                  Provider.of<ScheduleState>(context, listen: false)
                      .setSchedule(placeId.toString(), groupId.toString());
                });
              },
            )
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
      this.sunday2,
      this.formKey})
      : super(key: key);
  final ScheduleType schedule;
  final bool editMode;
  final GlobalKey<FormState>? formKey;
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
          return 'wednesday';
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: daysOfWeek
                .map((e) => Container(
                    width: 120,
                    margin: EdgeInsets.only(bottom: 16),
                    child: TimePill(e)))
                .toList()),
        Container(
            child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: daysOfWeek
                .map((e) => editMode
                    ? Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: schedule.days[getDayReverse(e)]!.isNotEmpty
                              ? [
                                  TimePill(
                                    schedule.days[getDayReverse(e)]![0]!,
                                    editMode: true,
                                    controller:
                                        getController(getDayReverse(e), 0),
                                    validator: (str) {
                                      if (str!.isEmpty &&
                                          getController(getDayReverse(e), 1)!
                                              .text
                                              .isNotEmpty)
                                        return 'Введите это поле';
                                      else if (str.isEmpty &&
                                          getController(getDayReverse(e), 1)!
                                              .text
                                              .isEmpty)
                                        return null;
                                      else
                                        return null;
                                    },
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  TimePill(
                                    schedule.days[getDayReverse(e)]![1]!,
                                    controller:
                                        getController(getDayReverse(e), 1),
                                    editMode: true,
                                    validator: (str) {
                                      if (str!.isEmpty &&
                                          getController(getDayReverse(e), 0)!
                                              .text
                                              .isNotEmpty)
                                        return 'Введите это поле';
                                      else if (str.isEmpty &&
                                          getController(getDayReverse(e), 0)!
                                              .text
                                              .isEmpty)
                                        return null;
                                      else
                                        return null;
                                    },
                                  ),
                                ]
                              : [
                                  TimePill(
                                    '',
                                    editMode: true,
                                    controller:
                                        getController(getDayReverse(e), 0),
                                    validator: (str) {
                                      if (str!.isEmpty &&
                                          getController(getDayReverse(e), 1)!
                                              .text
                                              .isNotEmpty)
                                        return 'Введите это поле';
                                      else if (str.isEmpty &&
                                          getController(getDayReverse(e), 1)!
                                              .text
                                              .isEmpty)
                                        return null;
                                      else
                                        return null;
                                    },
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  TimePill(
                                    '',
                                    editMode: true,
                                    controller:
                                        getController(getDayReverse(e), 1),
                                    validator: (str) {
                                      if (str!.isEmpty &&
                                          getController(getDayReverse(e), 0)!
                                              .text
                                              .isNotEmpty)
                                        return 'Введите это поле';
                                      else if (str.isEmpty &&
                                          getController(getDayReverse(e), 0)!
                                              .text
                                              .isEmpty)
                                        return null;
                                      else
                                        return null;
                                    },
                                  )
                                ],
                        ),
                      )
                    : schedule.days[getDayReverse(e)]!.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                TimePill(schedule.days[getDayReverse(e)]![0]!),
                                SizedBox(
                                  width: 16,
                                ),
                                TimePill(schedule.days[getDayReverse(e)]![1]!),
                              ],
                            ),
                          )
                        : Container(
                            height: 37,
                            margin: EdgeInsets.only(bottom: 16),
                          ))
                .toList(),
          ),
        ))
      ],
    );
  }
}

class TimePill extends StatelessWidget {
  const TimePill(this.text,
      {Key? key, this.editMode = false, this.controller, this.validator})
      : super(key: key);
  final String text;
  final bool editMode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    if (editMode)
      return GestureDetector(
        onLongPress: () {
          controller!.text = '';
        },
        onTap: () async {
          TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: controller!.text != ''
                  ? TimeOfDay(
                      hour: int.parse(controller!.text.split(':')[0]),
                      minute: int.parse(controller!.text.split(':')[1]))
                  : TimeOfDay(hour: 0, minute: 0));
          if (time != null) {
            controller!.text =
                '${time.hour < 10 ? '0' : ''}${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}';
          }
        },
        child: Input(
          enabled: false,
          height: 37,
          width: 82,
          controller: controller,
          validator: validator ?? (text) => null,
          defaultText: text,
          keyboardType: TextInputType.number,
          centerText: true,
          maxLength: 5,
          errorStyle: TextStyle(height: 0.01, fontSize: 0),
          textAlign: TextAlign.center,
          textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary),
        ),
      );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 37,
      width: 82,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.start,
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
      return 'wednesday';
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
