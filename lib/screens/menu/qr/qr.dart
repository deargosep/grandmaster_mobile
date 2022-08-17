import 'package:flutter/material.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<OptionType> list = [
      OptionType('Для мероприятий', '/qr/events'),
      OptionType('Для партнёров', '/qr/partners'),
    ];
    return CustomScaffold(
        appBar: AppHeader(
          text: 'QR коды',
        ),
        body: ListOfOptions(list: list));
  }
}
