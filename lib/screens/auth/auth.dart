import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/images/logo.dart';
import 'package:grandmaster/widgets/input.dart';

class AuthRegisterScreen extends StatelessWidget {
  const AuthRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Platform.operatingSystem == 'ios'
            ? Brightness.dark
            : Brightness.light));
    return CustomScaffold(
        body: Column(
      children: [
        Spacer(),
        Logo(),
        Spacer(),
        Text('Для авторизации введите номер телефона',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
            )),
        SizedBox(
          height: 32,
        ),
        Input(
          label: 'Номер телефона',
        ),
        Spacer(),
        BrandButton(
          text: 'Продолжить',
          type: 'primary',
          onPressed: () {
            Get.toNamed('/code');
          },
        ),
        SizedBox(
          height: 16,
        ),
        BrandButton(
            onPressed: () {
              Get.toNamed('/bar', arguments: 1);
            },
            text: 'Войти как гость',
            type: 'secondary'),
      ],
    ));
  }
}
