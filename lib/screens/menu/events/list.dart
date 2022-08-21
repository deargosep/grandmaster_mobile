import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/checkboxes_list.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

import '../../../state/groups.dart';

class EventMembersListScreen extends StatefulWidget {
  const EventMembersListScreen({Key? key}) : super(key: key);

  @override
  State<EventMembersListScreen> createState() => _EventMembersListScreenState();
}

class _EventMembersListScreenState extends State<EventMembersListScreen> {
  Map<String, bool>? checkboxes;

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
    EventType item = Get.arguments["item"];
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
  Map<String, bool>? checkboxes;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkboxes = {};
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GroupsState>(context, listen: false).setSportsmens();
      List sportsmens =
          Provider.of<GroupsState>(context, listen: false).sportsmens;
      setState(() {
        checkboxes = {
          for (var v in sportsmens) '${v["id"]}_${v["full_name"]}': false,
        };
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

    return CustomScaffold(
        bottomNavigationBar: BottomPanel(
          child: BrandButton(text: 'Записать'),
          withShadow: false,
        ),
        appBar: AppHeader(
          text: 'Записать спортсменов',
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<User> users = Get.arguments["item"].members;
      print(users);
      setState(() {
        checkboxes = {for (var v in users) v.fullName: false};
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

    return CustomScaffold(
        bottomNavigationBar: BottomPanel(
          child: BrandButton(text: 'Сохранить'),
          withShadow: false,
        ),
        appBar: AppHeader(
          text: 'Записать спортсменов',
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
    List<OptionType> list = Provider.of<UserState>(context)
        .user
        .children
        .map((e) => OptionType(e.fullName, '/success',
            arguments: 'Вы успешно записались на мероприятие'))
        .toList();
    return CustomScaffold(
        appBar: AppHeader(
          text: 'Выберите спортсмена',
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

class _View extends StatefulWidget {
  const _View({Key? key}) : super(key: key);

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  @override
  Widget build(BuildContext context) {
    List<OptionType> list =
        Get.arguments["item"].members.map((e) => OptionType(e.fullName, ''));
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
