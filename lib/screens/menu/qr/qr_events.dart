import 'package:flutter/material.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';

class QREvents extends StatelessWidget {
  const QREvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppHeader(
          text: 'Для мероприятий',
        ),
        body: Container(
          child: Image.asset(
            'assets/images/test_qr.png',
            height: 313,
            width: 313,
          ),
        ));
  }
}
