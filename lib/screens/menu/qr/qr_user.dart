import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../state/user.dart';
import '../../../utils/custom_scaffold.dart';
import '../../../widgets/images/logo.dart';

class QrUser extends StatelessWidget {
  const QrUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Get.arguments;
    return CustomScaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Logo(
              bigSize: false,
            ),
            SizedBox(
              height: 44,
            ),
            Text(
              user.fullName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 44,
            ),
            Text(
              DateFormat('dd.MM.y, H:mm').format(DateTime.now()),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
