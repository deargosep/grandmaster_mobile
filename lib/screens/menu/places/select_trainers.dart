import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
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
  var id = Get.arguments["id"];

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlacesState>(context, listen: false)
          .setTrainers()
          .then((value) {
        List<Trainer> trainers =
            Provider.of<PlacesState>(context, listen: false).trainers;
        List<PlaceType> places =
            Provider.of<PlacesState>(context, listen: false).places;
        setState(() {
          if (editMode) {
            checkboxes = {
              for (var v in trainers)
                '${v.id}_${v.fio}': places
                            .firstWhere((element) => element.id == id)
                            .trainers
                            .firstWhereOrNull(
                                (element) => element.id == v.id) !=
                        null
                    ? true
                    : false,
            };
          }
          checkboxes = {for (var v in trainers) '${v.id}_${v.fio}': false};
        });
      });
    });
  }

  bool editMode = Get.arguments["editMode"];
  FormData formData = Get.arguments["formData"];
  @override
  Widget build(BuildContext context) {
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
              FormData newFormData = formData;
              if (editMode) {
                newFormData.fields.add(MapEntry(
                    'trainers',
                    checkboxes!.entries
                        .where((element) => element.value)
                        .toList()
                        .map((e) => e.key.split('_')[0])
                        .toList()
                        .toString()));
                createDio()
                    .patch('/gyms/${id}/',
                        data: formData,
                        options: Options(contentType: 'multipart/form-data'))
                    .then((value) => Get.offAllNamed('/places'));
              } else {
                newFormData.fields.add(MapEntry(
                    'trainers',
                    checkboxes!.entries
                        .where((element) => element.value)
                        .toList()
                        .map((e) => e.key.split('_')[0])
                        .toList()
                        .toString()));
                createDio()
                    .post('/gyms/',
                        data: formData,
                        options: Options(contentType: 'multipart/form-data'))
                    .then((value) => Get.offAllNamed('/places'));
              }
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
