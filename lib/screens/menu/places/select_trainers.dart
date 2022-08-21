import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/checkboxes_list.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../utils/dio.dart';

class SelectTrainersScreen extends StatefulWidget {
  SelectTrainersScreen({Key? key}) : super(key: key);

  @override
  State<SelectTrainersScreen> createState() => _SelectTrainersScreenState();
}

class _SelectTrainersScreenState extends State<SelectTrainersScreen> {
  Map<String, bool>? checkboxes;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<Trainer> trainers =
          Provider.of<PlacesState>(context, listen: false).trainers;
      print(trainers);
      setState(() {
        // TODO
        // checkboxes = {
        //   for (var v in trainers)
        //     '${v["id"]}_${v["full_name"]}': group.members
        //         .firstWhereOrNull((element) => element.id == v["id"]) !=
        //         null
        //         ? true
        //         : false,
        // };
        checkboxes = {for (var v in trainers) v.fio: false};
      });
    });
  }

  bool editMode = Get.arguments["editMode"];
  @override
  Widget build(BuildContext context) {
    var dataPast = Get.arguments;
    void changeCheckboxesState(newState) {
      setState(() {
        checkboxes = newState;
      });
    }

    return CustomScaffold(
        scrollable: true,
        noTopPadding: true,
        bottomNavigationBar: BottomPanel(
          child: BrandButton(
            text: editMode ? 'Сохранить' : 'Опубликовать',
            onPressed: () {
              var data = {
                "title": dataPast["name"],
                "description": dataPast["description"],
                "address": dataPast["address"],
                "cover": dataPast["cover"]
              };
              createDio()
                  .post('/gyms/', data: data)
                  .then((value) => Get.offAllNamed('/places'));
            },
          ),
          withShadow: false,
        ),
        appBar: AppHeader(
          text: '${editMode ? 'Редактирование' : 'Создание'} зала',
        ),
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Укажите тренера(-ов)',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 32,
            ),
            CheckboxesList(
                checkboxes: checkboxes, changeCheckbox: changeCheckboxesState)
          ],
        ));
  }
}
