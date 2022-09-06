import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../state/user.dart';
import '../../../utils/dio.dart';
import '../../../widgets/checkboxes_list.dart';
import '../../../widgets/input.dart';

class GroupAddEditScreen extends StatefulWidget {
  const GroupAddEditScreen({Key? key}) : super(key: key);

  @override
  State<GroupAddEditScreen> createState() => _GroupAddEditScreenState();
}

class _GroupAddEditScreenState extends State<GroupAddEditScreen> {
  Map<String, bool>? checkboxes;
  GroupType? group = Get.arguments;
  TextEditingController name = TextEditingController();
  TextEditingController minAge = TextEditingController();
  TextEditingController maxAge = TextEditingController();
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    name.text = group?.name ?? '';
    minAge.text = group?.minAge.toString() ?? '';
    maxAge.text = group?.maxAge.toString() ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GroupsState>(context, listen: false)
          .setSportsmens()
          .then((value) {
        if (group != null) {
          List<MinimalUser> members = group!.members;
          setState(() {
            checkboxes = {
              for (var v in value)
                '${v.id}_${v.fullName}':
                    members.firstWhereOrNull((element) => element.id == v.id) !=
                        null
            };
            isLoaded = true;
          });
        } else {
          setState(() {
            checkboxes = {for (var v in value) '${v.id}_${v.fullName}': false};
            isLoaded = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void changeCheckboxesState(newState) {
      setState(() {
        checkboxes = newState;
      });
    }

    bool editMode = group != null;

    return CustomScaffold(
      // scrollable: true,
      noTopPadding: true,
      noPadding: false,
      noBottomPadding: true,
      appBar: AppHeader(
        text: '${editMode ? 'Редактирование' : 'Создание'} группы',
      ),
      bottomNavigationBar: BottomPanel(
        withShadow: false,
        child: BrandButton(
          text: Get.arguments != null ? 'Сохранить' : 'Опубликовать',
          onPressed: () {
            Map data;
            if (group != null) {
              data = {
                "name": name.text,
                "min_age": int.parse(minAge.text),
                "max_age": int.parse(maxAge.text),
                "members": [
                  ...?checkboxes?.entries
                      .where((map) => map.value)
                      .toList()
                      .map((e) => e.key.split('_')[0])
                ],
              };
              createDio()
                  .patch(
                '/sport_groups/${group?.id}/',
                data: data,
              )
                  .then((value) {
                log(value.toString());
                Provider.of<GroupsState>(context, listen: false).setGroups();
                Get.back();
              });
            } else {
              data = {
                "name": name.text,
                "min_age": int.parse(minAge.text),
                "max_age": int.parse(maxAge.text),
                "members": [
                  ...?checkboxes?.entries
                      .where((map) => map.value)
                      .toList()
                      .map((e) => e.key.split('_')[0])
                ],
                "trainer": Provider.of<UserState>(context, listen: false)
                    .user
                    .id
                    .toString()
              };
              createDio()
                  .post(
                '/sport_groups/',
                data: data,
              )
                  .then((value) {
                log(value.toString());
                Provider.of<GroupsState>(context, listen: false).setGroups();
                Get.back();
              });
            }
          },
        ),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
          ),
          Text(
            'Введите название группы',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary),
          ),
          SizedBox(
            height: 24,
          ),
          Input(
            label: 'Название',
            controller: name,
          ),
          SizedBox(
            height: 32,
          ),
          Text(
            'Укажите возрастную категорию',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Input(
                width: 124.0,
                height: 50.0,
                label: 'От',
                controller: minAge,
                centerText: true,
                keyboardType: TextInputType.number,
              ),
              Container(
                width: 55,
                height: 2,
                color: Color(0xFFC9C9C9),
              ),
              Input(
                label: 'До',
                width: 124.0,
                height: 50.0,
                controller: maxAge,
                centerText: true,
                keyboardType: TextInputType.number,
              )
            ],
          ),
          SizedBox(
            height: 32,
          ),
          isLoaded
              ? CheckboxesList(
                  changeCheckbox: changeCheckboxesState,
                  checkboxes: checkboxes,
                )
              : Center(
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }
}
