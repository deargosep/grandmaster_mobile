import 'package:flutter/material.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    List<OptionType> getList() {
      Map<String, String> links = {
        "events": '/events',
        "videos": '/videos',
        "learning": "/learnings",
        "places": '/places',
        "payment": '/payment',
        "qr": '/qr',
        'about': '/about',
        'visits': '/journal',
        'schedule': '/schedule',
        'groups': '/groups',
      };
      if (user.children.isNotEmpty || user.role == 'sportsmen') {
        return <OptionType>[
          OptionType('Мероприятия', links["events"]!),
          OptionType('Видео', links["videos"]!),
          OptionType('Учебные материалы', links["learning"]!),
          OptionType('Залы', links["places"]!),
          OptionType('Оплата', links["payment"]!),
          OptionType('QR коды', links["qr"]!),
          OptionType('О клубе', links["about"]!)
        ];
      }
      if (user.role == 'trainer') {
        return <OptionType>[
          OptionType('Мероприятия', links["events"]!),
          OptionType('Учебные файлы', links["learning"]!),
          OptionType('Журнал посещений', links["visits"]!),
          OptionType('Расписание', links["schedule"]!),
          OptionType('Залы', links["places"]!),
          OptionType('Видео', links["videos"]!),
          OptionType('Оплата', links["payment"]!),
          OptionType('QR коды', links["qr"]!),
          OptionType('Группы спортсменов', links["groups"]!),
          OptionType('О клубе', links["about"]!),
        ];
      }
      if (user.role == 'student') {
        return <OptionType>[
          OptionType('Мероприятия', links["events"]!),
          // OptionType('Расписание', links["schedule"]!),
          OptionType('Видео', links["videos"]!),
          OptionType('Залы', links["places"]!),
          OptionType('QR коды', links["qr"]!),
          OptionType('О клубе', links["about"]!)
        ];
      }
      if (user.role == 'moderator') {
        return <OptionType>[
          OptionType('Мероприятия', links["events"]!),
          OptionType('Учебные файлы', links["learning"]!),
          OptionType('Журнал посещений', links["visits"]!),
          // OptionType('Расписание', links["schedule"]!),
          OptionType('Залы', links["places"]!),
          OptionType('Видео', links["videos"]!),
          OptionType('QR коды', links["qr"]!),
          OptionType('Группы спортсменов', links["groups"]!),
          OptionType('О клубе', links["about"]!),
        ];
      }
      if (user.role == 'guest') {
        return <OptionType>[
          OptionType('О клубе', links["about"]!),
        ];
      }
      return <OptionType>[];
    }

    return CustomScaffold(
      // scrollable: true,
      noPadding:false,
      appBar: AppHeader(
        text: 'Меню пользователя',
        withBack: false,
      ),
      padding: EdgeInsets.only(left: 20, right: 20, top: 16),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [ListOfOptions(list: getList())],
      ),
    );
  }
}
