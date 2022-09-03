import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  User user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final destination = '/my_profile/documents/document';
    List<OptionType> optionList = [
      OptionType('Паспорт / Свидетельство о рождении', destination,
          arguments: {"index": 0, "user": user}),
      OptionType('Полис ОМС', destination,
          arguments: {"index": 1, "user": user}),
      OptionType('Справка из школы', destination,
          arguments: {"index": 2, "user": user}),
      OptionType('Страховой полис', destination,
          arguments: {"index": 3, "user": user}),
      OptionType('Диплом о технической квалификации', destination,
          arguments: {"index": 4, "user": user}),
      OptionType('Медицинская справка', destination,
          arguments: {"index": 5, "user": user}),
      OptionType('Загранпаспорт', destination,
          arguments: {"index": 6, "user": user}),
      OptionType('ИНН', destination, arguments: {"index": 7, "user": user}),
      OptionType('Диплом об образовании', destination,
          arguments: {"index": 8, "user": user}),
      OptionType('СНИЛС', destination, arguments: {"index": 9, "user": user}),
      OptionType('Другие документы', destination,
          arguments: {"type": "other", "user": user})
    ];
    if (user.role == 'trainer') {
      optionList = [
        OptionType('Паспорт', destination,
            arguments: {"index": 0, "user": user}),
        OptionType('Полис ОМС', destination,
            arguments: {"index": 1, "user": user}),
        OptionType('Страховой полис', destination,
            arguments: {"index": 2, "user": user}),
        OptionType('Диплом о технической квалификации', destination,
            arguments: {"index": 3, "user": user}),
        // OptionType('Медицинская справка', destination, arguments: 5),
        OptionType('Загранпаспорт', destination,
            arguments: {"index": 4, "user": user}),
        OptionType('ИНН', destination, arguments: {"index": 5, "user": user}),
        OptionType('Диплом об образовании', destination,
            arguments: {"index": 6, "user": user}),
        OptionType('СНИЛС', destination, arguments: {"index": 7, "user": user}),
        OptionType('Другие документы', destination,
            arguments: {"type": "other", "user": user})
      ];
    }
    return CustomScaffold(
        noTopPadding: true,
        noPadding: false,
        appBar: AppHeader(
          text: 'Документы',
        ),
        body: ListView(
          children: [
            ListOfOptions(
              list: optionList,
            )
          ],
        ));
  }
}
