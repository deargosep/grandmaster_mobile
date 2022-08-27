import 'package:flutter/material.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final destination = '/my_profile/documents/document';
    List<OptionType> optionList = [
      OptionType('Паспорт / Свидетельство о рождении', destination,
          arguments: 0),
      OptionType('Полис ОМС', destination, arguments: 1),
      OptionType('Справка из школы', destination, arguments: 2),
      OptionType('Страховой полис', destination, arguments: 3),
      OptionType('Диплом о технической квалификации', destination,
          arguments: 4),
      OptionType('Медицинская справка', destination, arguments: 5),
      OptionType('Загранпаспорт', destination, arguments: 6),
      OptionType('ИНН', destination, arguments: 7),
      OptionType('Диплом об образовании', destination, arguments: 8),
      OptionType('СНИЛС', destination, arguments: 9)
    ];
    User user = Provider.of<UserState>(context, listen: false).user;
    if (user.role == 'trainer') {
      optionList = [
        OptionType('Паспорт', destination, arguments: 0),
        OptionType('Полис ОМС', destination, arguments: 1),
        OptionType('Страховой полис', destination, arguments: 3),
        OptionType('Диплом о технической квалификации', destination,
            arguments: 4),
        // OptionType('Медицинская справка', destination, arguments: 5),
        OptionType('Загранпаспорт', destination, arguments: 6),
        OptionType('ИНН', destination, arguments: 7),
        OptionType('Диплом об образовании', destination, arguments: 8),
        OptionType('СНИЛС', destination, arguments: 9)
      ];
    }
    return CustomScaffold(
        noTopPadding: true,
        scrollable: true,
        appBar: AppHeader(
          text: 'Документы',
        ),
        body: Column(
          children: [
            ListOfOptions(
              list: optionList,
            )
          ],
        ));
  }
}
