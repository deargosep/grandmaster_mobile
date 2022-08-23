import 'package:flutter/material.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';

class QRPartners extends StatelessWidget {
  const QRPartners({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppHeader(
          text: 'Для партнеров',
        ),
        body: Container(
          child: Image.asset(
            'assets/images/partners_qr.png',
            height: 313,
            width: 313,
          ),
        ));
  }
}
