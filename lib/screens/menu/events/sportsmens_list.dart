import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/checkboxes_list.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

import '../../../utils/dio.dart';

class EventMembersListScreen extends StatefulWidget {
  const EventMembersListScreen({Key? key}) : super(key: key);

  @override
  State<EventMembersListScreen> createState() => _EventMembersListScreenState();
}

class _EventMembersListScreenState extends State<EventMembersListScreen> {
  Map<String, bool>? checkboxes;
  late List sportsmens;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // List<User> users = Provider.of<UserState>(context, listen: false).list;
      // print(users);
      // setState(() {
      //   checkboxes = {for (var v in users) v.fullName: false};
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    // EventType item = Get.arguments["item"];
    var options = Get.arguments["options"];
    void changeCheckbox(value) {
      setState(() {
        checkboxes = value;
      });
    }

    var user = Provider.of<UserState>(context, listen: false).user;
    switch (options["type"]) {
      case 'add':
        return _Add();
      case 'choose':
        return _Choose();
      case 'view':
        return _View();
      case 'edit':
        return _Edit();
      default:
        return _View();
    }

    return CustomScaffold(
        appBar: AppHeader(
          text: 'Редактировать список',
        ),
        noTopPadding: true,
        scrollable: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              'Добавьте/уберите участников',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 32,
            ),
            CheckboxesList(
              changeCheckbox: changeCheckbox,
              checkboxes: checkboxes,
            ),
          ],
        ));
  }
}

class _Add extends StatefulWidget {
  const _Add({Key? key}) : super(key: key);

  @override
  State<_Add> createState() => _AddState();
}

class _AddState extends State<_Add> {
  late Map<String, bool> checkboxes;
  bool isLoaded = false;
  EventType item = Get.arguments["item"];

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<MinimalUser> sportsmens = item.members;
      // List sportsmens =
      //     Provider.of<GroupsState>(context, listen: false).sportsmens;
      // .events
      // .firstWhere((element) => item.id == element.id)
      // .members;
      setState(() {
        checkboxes = {
          for (var v in sportsmens) '${v.id}_${v.fullName}': v.marked!,
        };
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void changeCheckbox(value) {
      setState(() {
        checkboxes = value;
      });
    }

    // FormData? formData = Get.arguments["formData"];

    return CustomScaffold(
        bottomNavigationBar: BottomPanel(
          child: BrandButton(
            text: 'Записать',
            onPressed: () {
              List members = checkboxes.entries
                  .where((element) => element.value)
                  .toList()
                  .map((e) => int.parse(e.key.split('_')[0]))
                  .toList();
              // formData?.fields.add(MapEntry("members", members.toString()));
              createDio().put(
                '/events/members/?event=${item.id}',
                data: {"members": members},
              ).then((value) {
                Provider.of<EventsState>(context, listen: false).setEvents();
                Get.back();
                Get.back();
              });
            },
          ),
          withShadow: false,
        ),
        appBar: AppHeader(
          text: 'Записать спортсменов',
        ),
        noTopPadding: true,
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              'Добавьте участников',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 32,
            ),
            !isLoaded
                ? Center(child: CircularProgressIndicator())
                : CheckboxesList(
                    changeCheckbox: changeCheckbox,
                    checkboxes: checkboxes,
                  ),
          ],
        ));
  }
}

class _Edit extends StatefulWidget {
  const _Edit({Key? key}) : super(key: key);

  @override
  State<_Edit> createState() => _EditState();
}

class _EditState extends State<_Edit> {
  Map<String, bool>? checkboxes;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<MinimalUser> members = item.members;
      // List<MinimalUser?> users =
      //     await Provider.of<GroupsState>(context, listen: false)
      //         .setSportsmens();
      setState(() {
        checkboxes = {
          for (var v in members) '${v.id}_${v.fullName}': v.marked!
        };
      });
    });
  }

  EventType item = Get.arguments["item"];
  @override
  Widget build(BuildContext context) {
    void changeCheckbox(value) {
      setState(() {
        checkboxes = value;
      });
    }

    return CustomScaffold(
        noPadding: false,
        noBottomPadding: true,
        bottomNavigationBar: BottomPanel(
          child: BrandButton(
            text: 'Сохранить',
            onPressed: () {
              createDio().put('/events/members/?event=${item.id}', data: {
                "members": checkboxes?.entries
                    .where((e) => e.value)
                    .toList()
                    .map((e) => int.parse(e.key.split('_')[0]))
                    .toList()
              }).then((value) {
                Get.back();
                Provider.of<EventsState>(context, listen: false).setEvents();
              });
            },
          ),
          withShadow: false,
        ),
        appBar: AppHeader(
          text: 'Записать спортсменов',
        ),
        noTopPadding: true,
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              'Добавьте участников',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 32,
            ),
            CheckboxesList(
              changeCheckbox: changeCheckbox,
              checkboxes: checkboxes,
            ),
          ],
        ));
  }
}

class _Choose extends StatefulWidget {
  const _Choose({Key? key}) : super(key: key);

  @override
  State<_Choose> createState() => _ChooseState();
}

class _ChooseState extends State<_Choose> {
  @override
  Widget build(BuildContext context) {
    EventType item = Get.arguments["item"];
    List<Option> list = Provider.of<UserState>(context)
        .user
        .children
        .map((e) => Option(
            text: e.fullName,
            noArrow: true,
            onTap: () {
              createDio().put('/events/members/?event=${item.id}', data: {
                "members": [e.id]
              }).then((value) {
                Get.back();
                Provider.of<EventsState>(context, listen: false).setEvents();
              });
            }))
        .toList();
    return CustomScaffold(
        appBar: AppHeader(
          text: 'Выберите спортсмена',
        ),
        noTopPadding: true,
        noPadding: false,
        scrollable: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            ...list
          ],
        ));
  }
}

class _View extends StatefulWidget {
  const _View({Key? key}) : super(key: key);

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  @override
  Widget build(BuildContext context) {
    EventType item = Get.arguments["item"];
    List<OptionType> list = item.members
        .map((e) => OptionType(e.fullName, '/other_profile',
            arguments: User(
                fullName: e.fullName, photo: e.photo, passport: Passport())))
        .toList();
    return CustomScaffold(
        appBar: AppHeader(
          text: 'Просмотр участников',
        ),
        noTopPadding: true,
        scrollable: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            ListOfOptions(
              list: list,
              noArrow: true,
            )
          ],
        ));
  }
}
