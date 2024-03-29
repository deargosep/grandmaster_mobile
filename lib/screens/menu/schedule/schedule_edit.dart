import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/schedule.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import 'schedule_table.dart';

class EditScheduleScreen extends StatefulWidget {
  EditScheduleScreen({Key? key}) : super(key: key);

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  TextEditingController monday1 = TextEditingController();
  TextEditingController monday2 = TextEditingController();
  TextEditingController tuesday1 = TextEditingController();
  TextEditingController tuesday2 = TextEditingController();
  TextEditingController wednesday1 = TextEditingController();
  TextEditingController wednesday2 = TextEditingController();
  TextEditingController thursday1 = TextEditingController();
  TextEditingController thursday2 = TextEditingController();
  TextEditingController friday1 = TextEditingController();
  TextEditingController friday2 = TextEditingController();
  TextEditingController saturday1 = TextEditingController();
  TextEditingController saturday2 = TextEditingController();
  TextEditingController sunday1 = TextEditingController();
  TextEditingController sunday2 = TextEditingController();

  var arguments = Get.arguments;
  var placeId = Get.arguments["placeId"];
  var groupId = Get.arguments["groupId"];
  var createMode = Get.arguments["createMode"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScheduleType schedule =
          Provider.of<ScheduleState>(context, listen: false).schedule;
      if (schedule.days["monday"]!.isNotEmpty) {
        monday1.text = schedule.days["monday"]?[0] ?? '';
        monday2.text = schedule.days["monday"]?[1] ?? '';
      }
      if (schedule.days["tuesday"]!.isNotEmpty) {
        tuesday1.text = schedule.days["tuesday"]?[0] ?? '';
        tuesday2.text = schedule.days["tuesday"]?[1] ?? '';
      }
      if (schedule.days["wednesday"]!.isNotEmpty) {
        wednesday1.text = schedule.days["wednesday"]?[0] ?? '';
        wednesday2.text = schedule.days["wednesday"]?[1] ?? '';
      }
      if (schedule.days["thursday"]!.isNotEmpty) {
        thursday1.text = schedule.days["thursday"]?[0] ?? '';
        thursday2.text = schedule.days["thursday"]?[1] ?? '';
      }
      if (schedule.days["friday"]!.isNotEmpty) {
        friday1.text = schedule.days["friday"]?[0] ?? '';
        friday2.text = schedule.days["friday"]?[1] ?? '';
      }
      if (schedule.days["saturday"]!.isNotEmpty) {
        saturday1.text = schedule.days["saturday"]?[0] ?? '';
        saturday2.text = schedule.days["saturday"]?[1] ?? '';
      }
      if (schedule.days["sunday"]!.isNotEmpty) {
        sunday1.text = schedule.days["sunday"]?[0] ?? '';
        sunday2.text = schedule.days["sunday"]?[1] ?? '';
      }
    });
  }

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Map<String, List<String>> schedule = {
    //   "Понедельник": ['10:30', '10:30'],
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
        bottomNavigationBar: BottomPanel(
            withShadow: false,
            child: BrandButton(
              text: 'Сохранить',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Map days = {
                    "monday": [monday1.text, monday2.text],
                    "tuesday": [tuesday1.text, tuesday2.text],
                    "wednesday": [wednesday1.text, wednesday2.text],
                    "thursday": [thursday1.text, thursday2.text],
                    "friday": [friday1.text, friday2.text],
                    "saturday": [saturday1.text, saturday2.text],
                    "sunday": [sunday1.text, sunday2.text],
                  };
                  if (!days.values.every((element) =>
                      element.every((e) => e == ''))) if (createMode !=
                          null &&
                      createMode == true) {
                    createDio().post('/schedule/', data: {
                      "gym": placeId.toString(),
                      "sport_group": groupId.toString(),
                      "days": days
                    }).then((value) {
                      Get.back();
                      Provider.of<ScheduleState>(context, listen: false)
                          .setSchedule(placeId, groupId);
                    });
                  } else {
                    createDio().put('/schedule/', data: {
                      "gym": schedule.gym.toString(),
                      "sport_group": schedule.group.toString(),
                      "days": days
                    }).then((value) {
                      Get.back();
                      Provider.of<ScheduleState>(context, listen: false)
                          .setSchedule(schedule.gym, schedule.group);
                    });
                  }
                }
              },
            )),
        appBar: AppHeader(
          text:
              createMode != null && createMode ? 'Создание' : 'Редактирование',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Schedule(schedule,
                formKey: formKey,
                editMode: true,
                monday1: monday1,
                monday2: monday2,
                tuesday1: tuesday1,
                tuesday2: tuesday2,
                wednesday1: wednesday1,
                wednesday2: wednesday2,
                thursday1: thursday1,
                thursday2: thursday2,
                friday1: friday1,
                friday2: friday2,
                saturday1: saturday1,
                saturday2: saturday2,
                sunday1: sunday1,
                sunday2: sunday2)
          ],
        ));
  }
}
