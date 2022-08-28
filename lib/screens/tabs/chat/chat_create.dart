import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/checkboxes_list.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../widgets/input.dart';

class ChatCreateScreen extends StatefulWidget {
  const ChatCreateScreen({Key? key}) : super(key: key);

  @override
  State<ChatCreateScreen> createState() => _ChatCreateScreenState();
}

class _ChatCreateScreenState extends State<ChatCreateScreen> {
  late Map<String, bool> checkboxes;
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      createDio().get('/chats/members/').then((value) {
        print(value.data);
        List<MinimalUser> members = [
          ...value.data
              .map((e) => MinimalUser(
                  fullName: e["full_name"],
                  id: e["id"],
                  role: UserState().getRole(e["contact_type"])))
              .toList()
        ];
        setState(() {
          checkboxes = {
            for (var v in members) '${v.id}_${v.fullName}': false,
          };
          isLoaded = true;
        });
      });
      // List sportsmens =
      //     Provider.of<GroupsState>(context, listen: false).sportsmens;
      // .events
      // .firstWhere((element) => item.id == element.id)
      // .members;
    });
  }

  void changeCheckbox(newCheckboxes) {
    if (mounted)
      setState(() {
        checkboxes = newCheckboxes;
      });
  }

  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        noPadding: false,
        noTopPadding: true,
        noBottomPadding: true,
        appBar: AppHeader(
          text: 'Создание чата',
        ),
        bottomNavigationBar: BottomPanel(
            child: BrandButton(
          text: 'Создать',
          onPressed: () {
            createDio().post('/chats/', data: {
              "name": name.text,
              "members": [
                ...checkboxes.entries
                    .where((element) => element.value)
                    .map((e) => int.parse(e.key.split('_')[0]))
                    .toList()
              ]
            }).then((value) {
              Provider.of<ChatsState>(context, listen: false).setChats();
              Get.back();
            });
          },
        )),
        body: ListView(
          children: [
            SizedBox(
              height: 24,
            ),
            Text(
              'Введите название',
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
            CheckboxesList(
              changeCheckbox: changeCheckbox,
              checkboxes: checkboxes,
            )
          ],
        ));
  }
}
