import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../state/chats.dart';
import '../../../state/user.dart';
import '../../../utils/dio.dart';
import '../../../widgets/checkboxes_list.dart';
import '../../../widgets/input.dart';

class ChatEditScreen extends StatefulWidget {
  const ChatEditScreen({Key? key}) : super(key: key);

  @override
  State<ChatEditScreen> createState() => _ChatEditScreenState();
}

class _ChatEditScreenState extends State<ChatEditScreen> {
  Map<String, bool>? checkboxes;
  ChatType? chat = Get.arguments;
  TextEditingController name = TextEditingController();
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    name.text = chat?.name ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await Provider.of<ChatsState>(context, listen: false).setChats();
      createDio().get('/chats/members/').then((value) {
        List<MinimalUser> members = [
          ...value.data
              .map((e) => MinimalUser(
                  fullName: e["full_name"],
                  id: e["id"],
                  role: UserState().getRole(e["contact_type"])))
              .toList()
        ];
        List<MinimalUser> chatmembers = chat!.members;
        members.sort((a, b) {
          return a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
        });
        if (mounted)
          setState(() {
            checkboxes = {
              for (var v in members)
                '${v.id}_${v.fullName}_${v.isAdmitted}': chatmembers
                        .firstWhereOrNull((element) => element.id == v.id) !=
                    null
            };
            isLoaded = true;
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

    bool editMode = chat != null;

    return CustomScaffold(
      // scrollable: true,
      noTopPadding: true,
      noPadding: false,
      noBottomPadding: true,
      appBar: AppHeader(
        text: "Редактирование чата",
      ),
      bottomNavigationBar: BottomPanel(
        withShadow: false,
        child: BrandButton(
          text: Get.arguments != null ? 'Сохранить' : 'Опубликовать',
          onPressed: () {
            if (name.text.trim() != '') {
              Map data;
              data = {
                "name": name.text,
                "members": [
                  ...?checkboxes?.entries
                      .where((map) => map.value)
                      .toList()
                      .map((e) => e.key.split('_')[0])
                ],
              };
              createDio()
                  .patch(
                '/chats/${chat?.id}/',
                data: data,
              )
                  .then((value) {
                Provider.of<ChatsState>(context, listen: false).setChats();
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
            'Название чата',
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
            height: 24,
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
