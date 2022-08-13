import 'package:flutter/material.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../state/user.dart';
import '../../../widgets/checkboxes_list.dart';
import '../../../widgets/input.dart';

class GroupAddScreen extends StatefulWidget {
  const GroupAddScreen({Key? key}) : super(key: key);

  @override
  State<GroupAddScreen> createState() => _GroupAddScreenState();
}

class _GroupAddScreenState extends State<GroupAddScreen> {
  Map<String, bool>? checkboxes;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<User> users = Provider.of<UserState>(context, listen: false).list;
      setState(() {
        checkboxes = {for (var v in users) v.fullName: false};
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
      scrollable: true,
      noTopPadding: true,
      appBar: AppHeader(
        text: 'Создание группы',
      ),
      bottomNavigationBar: BottomPanel(
          withShadow: false,
          child: BrandButton(
            text: 'Продолжить',
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                centerText: true,
              )
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Expanded(
            child: CheckboxesList(
              changeCheckbox: changeCheckboxesState,
              checkboxes: checkboxes,
            ),
          )
        ],
      ),
    );
  }
}
