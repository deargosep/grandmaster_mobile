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

class GroupAddScreen extends StatefulWidget {
  const GroupAddScreen({Key? key}) : super(key: key);

  @override
  State<GroupAddScreen> createState() => _GroupAddScreenState();
}

class _GroupAddScreenState extends State<GroupAddScreen> {
  Map<String, bool>? checkboxes;

  TextEditingController name = TextEditingController();
  TextEditingController minAge = TextEditingController();
  TextEditingController maxAge = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GroupsState>(context, listen: false)
          .setSportsmens()
          .then((value) {
        setState(() {
          checkboxes = {
            for (var v in value) '${v["id"]}_${v["full_name"]}': false
          };
        });
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

    return CustomScaffold(
      // scrollable: true,
      noTopPadding: true,
      appBar: AppHeader(
        text: 'Создание группы',
      ),
      bottomNavigationBar: BottomPanel(
        withShadow: false,
        child: BrandButton(
          text: Get.arguments != null ? 'Сохранить' : 'Опубликовать',
          onPressed: () {
            Map data = {
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
              )
            ],
          ),
          SizedBox(
            height: 32,
          ),
          CheckboxesList(
            changeCheckbox: changeCheckboxesState,
            checkboxes: checkboxes,
          )
        ],
      ),
    );
  }
}