import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';

import '../../../utils/dio.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  User user = Get.arguments;
  bool isLoaded = false;
  late Map documents;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted)
        setState(() {
          isLoaded = false;
        });
      createDio().get(user.documentsUrl!).then((value) {
        if (mounted)
          setState(() {
            isLoaded = true;
            documents = Map<String, dynamic>.from(value.data);
          });
        print(documents);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map> documentsList = [
      {
        "title": 'Паспорт / Свидетельство о рождении',
        "code": "passport_or_birth_certificate"
      },
      {"title": 'Полис ОМС', "code": "oms_policy"},
      {"title": 'Справка из школы', "code": "school_ref"},
      {"title": 'Страховой полис', "code": "insurance_policy"},
      {"title": 'Диплом о технической квалификации', "code": "tech_qual_diplo"},
      {"title": 'Медицинская справка', "code": "med_certificate"},
      {"title": 'Загранпаспорт', "code": "foreign_passport"},
      {"title": 'ИНН', "code": "inn"},
      {"title": 'Диплом об образовании', "code": "diploma"},
      {"title": 'СНИЛС', "code": "snils"},
    ];
    if (!isLoaded)
      return CustomScaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    final destination = '/my_profile/documents/document';
    List<OptionType> optionList = [
      OptionType('Паспорт / Свидетельство о рождении', destination,
          arguments: {"index": 0, "user": user, "documents": documents}),
      OptionType('Полис ОМС', destination,
          arguments: {"index": 1, "user": user, "documents": documents},
          red: documents[documentsList[1]["code"]] == null),
      OptionType('Справка из школы', destination,
          arguments: {"index": 2, "user": user, "documents": documents}),
      OptionType('Страховой полис', destination,
          arguments: {"index": 3, "user": user, "documents": documents},
          red: documents[documentsList[3]["code"]] == null),
      OptionType('Диплом о технической квалификации', destination,
          arguments: {"index": 4, "user": user, "documents": documents}),
      OptionType('Медицинская справка', destination,
          arguments: {"index": 5, "user": user, "documents": documents},
          red: documents[documentsList[5]["code"]] == null),
      OptionType('Загранпаспорт', destination,
          arguments: {"index": 6, "user": user, "documents": documents}),
      OptionType('ИНН', destination,
          arguments: {"index": 7, "user": user, "documents": documents}),
      OptionType('Диплом об образовании', destination,
          arguments: {"index": 8, "user": user, "documents": documents}),
      OptionType('СНИЛС', destination,
          arguments: {"index": 9, "user": user, "documents": documents}),
      OptionType('Другие документы', destination,
          arguments: {"type": "other", "user": user})
    ];
    if (user.role == 'trainer') {
      optionList = [
        OptionType('Паспорт', destination,
            arguments: {"index": 0, "user": user, "documents": documents}),
        OptionType('Полис ОМС', destination,
            arguments: {"index": 1, "user": user, "documents": documents}),
        OptionType('Страховой полис', destination,
            arguments: {"index": 2, "user": user, "documents": documents}),
        OptionType('Диплом о технической квалификации', destination,
            arguments: {"index": 3, "user": user, "documents": documents}),
        // OptionType('Медицинская справка', destination, arguments: 5),
        OptionType('Загранпаспорт', destination,
            arguments: {"index": 4, "user": user, "documents": documents}),
        OptionType('ИНН', destination,
            arguments: {"index": 5, "user": user, "documents": documents}),
        OptionType('Диплом об образовании', destination,
            arguments: {"index": 6, "user": user, "documents": documents}),
        OptionType('СНИЛС', destination,
            arguments: {"index": 7, "user": user, "documents": documents}),
        OptionType('Другие документы', destination,
            arguments: {"type": "other", "user": user, "documents": documents})
      ];
    }
    return CustomScaffold(
        noTopPadding: true,
        noPadding: false,
        noBottomPadding: true,
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
