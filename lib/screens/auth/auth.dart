import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/images/logo.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRegisterScreen extends StatefulWidget {
  const AuthRegisterScreen({Key? key}) : super(key: key);

  @override
  State<AuthRegisterScreen> createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> {
  late TextEditingController phoneNumber =
      TextEditingController(text: '+79515251625');

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      if (value.getString('access') != null) {
        createDio()
            .get(
          '/users/self/',
        )
            .then((value) {
          if (value.statusCode == 200) {
            Provider.of<UserState>(context, listen: false).setUser(value.data);
            Get.offAllNamed('/bar', arguments: 1);
          }
        }, onError: (err) {
          print(err);
          if (err.statusCode == 401) {
            createDio().post('/auth/token/refresh/',
                data: {"refresh": value.getString('refresh')},
                options: Options(headers: {"Authorization": null}));
          }
        });
      }
    });
  }

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
          controller: phoneNumber,
        ),
        Spacer(),
        BrandButton(
            text: 'Продолжить',
            type: 'primary',
            onPressed: () {
              SharedPreferences.getInstance().then((value) => value.clear());
              createDio()
                  .post('/auth/send_code/',
                      data: {
                        "phone_number": phoneNumber.text,
                      },
                      options: Options(headers: {}))
                  .then((value) =>
                      Get.toNamed('/code', arguments: phoneNumber.text));
            }),
        SizedBox(
          height: 16,
        ),
        BrandButton(
            onPressed: () {
              Get.offAllNamed('/bar', arguments: 1);
            },
            text: 'Войти как гость',
            type: 'secondary'),
      ],
    ));
  }
}
