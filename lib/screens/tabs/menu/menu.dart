import 'package:flutter/material.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    List<OptionType> getList() {
      if (user.role == 'parent') {
        return <OptionType>[
          OptionType('Мероприятия', '/events'),
          OptionType('Видео', ''),
          OptionType('Учебные материалы', ''),
          OptionType('Залы', ''),
          OptionType('Оплата', ''),
          OptionType('QR коды', ''),
          OptionType('О клубе', '')
        ];
      }
      if (user.role == 'trainer') {
        return <OptionType>[
          OptionType('Мероприятия', '/events'),
          OptionType('Учебные файлы', ''),
          OptionType('Журнал посещений', ''),
          OptionType('Расписание', ''),
          OptionType('Залы', ''),
          OptionType('Видео', ''),
          OptionType('Оплата', ''),
          OptionType('QR коды', ''),
          OptionType('Группы спортсменов', ''),
          OptionType('О клубе', ''),
        ];
      }
      if (user.role == 'student') {
        return <OptionType>[
          OptionType('Расписание', ''),
          OptionType('Залы', ''),
          OptionType('Оплата', ''),
          OptionType('QR коды', ''),
          OptionType('О клубе', '')
        ];
      }
      if (user.role == 'moderator') {
        return <OptionType>[
          OptionType('Мероприятия', '/events'),
          OptionType('Учебные файлы', ''),
          OptionType('Журнал посещений', ''),
          OptionType('Расписание', ''),
          OptionType('Залы', ''),
          OptionType('Видео', ''),
          OptionType('QR коды', ''),
          OptionType('Группы спортсменов', ''),
          OptionType('О клубе', ''),
          OptionType('Тренеры', '')
        ];
      }
      if (user.role == 'guest') {
        return <OptionType>[
          OptionType('Залы', ''),
          OptionType('Видео', ''),
          OptionType('О клубе', ''),
        ];
      }
      return <OptionType>[];
    }

    return CustomScaffold(
      scrollable: true,
      appBar: AppHeader(
        text: 'Меню пользователя',
        withBack: false,
      ),
      padding: EdgeInsets.only(left: 20, right: 20),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ListOfOptions(list: getList())],
      ),
    );
  }
}

class _ListOfOptions extends StatelessWidget {
  const _ListOfOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Option(text: 'Мероприятия'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'Видео'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'Учебные материалы'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'Залы'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'Оплата'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'QR коды'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'О клубе'),
      ],
    );
  }
}
