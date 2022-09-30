import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/images/logo.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class InputCodeScreen extends StatefulWidget {
  InputCodeScreen({Key? key}) : super(key: key);

  @override
  State<InputCodeScreen> createState() => _InputCodeScreenState();
}

class _InputCodeScreenState extends State<InputCodeScreen> {
  bool error = false;
  TextEditingController controller = TextEditingController(text: '12345');
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Get.arguments == null) {
        Get.offAllNamed('/');
      }
    });
  }

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        noPadding: false,
        bottomNavigationBar: BottomPanel(
          withShadow: false,
          child: BrandButton(
            disabled: error,
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              createDio().post('/auth/validate_code/', data: {
                "phone_number": Get.arguments["raw"],
                "code": controller.text
              }).then((value) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('access', value.data["access"]);
                await prefs.setString('refresh', value.data["refresh"]);
                createDio().get('/users/self/').then((value) {
                  log(value.data.toString());
                  var data = value.data;
                  log(data.toString());
                  if (isValidContactType(value.data["CONTACT_TYPE"])) {
                    Provider.of<UserState>(context, listen: false)
                        .setUser(data);
                    FocusManager.instance.primaryFocus?.unfocus();
                    Get.offAllNamed('/bar', arguments: 1);
                  }
                });
              });
            },
            text: 'Вход',
            type: 'primary',
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Spacer(),
              Logo(),
              Spacer(),
              Text('Код отправлен на номер',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
              SizedBox(
                height: 8,
              ),
              Text('${Get.arguments["formatted"]}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
              SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  Get.offAllNamed('/');
                },
                child: Text(
                  "Не ваш номер?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Input(
                padding: EdgeInsets.only(left: 16, right: 16),
                width: 120,
                textAlign: TextAlign.center,
                controller: controller,
                keyboardType: TextInputType.number,
                labelWidget: Center(
                  child: Text('Код'),
                ),
                errorStyle: TextStyle(height: 0.01, color: Colors.transparent),
                onChanged: (text) {
                  if (text.length < 5) {
                    if (mounted)
                      setState(() {
                        error = true;
                      });
                  } else {
                    if (mounted)
                      setState(() {
                        error = false;
                      });
                  }
                },
                validator: (text) {
                  if (text!.length < 5) {
                    return 'Введите код';
                  } else {
                    return null;
                  }
                },
                maxLength: 5,
              ),
              SizedBox(
                height: 32,
              ),
              Timer(),
            ],
          ),
        ));
  }
}

class Timer extends StatefulWidget {
  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  CountdownController controller = CountdownController(autoStart: true);
  var arguments = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Countdown(
      seconds: 60,
      controller: controller,
      build: (BuildContext context, double time) {
        if (time.seconds.inSeconds == 0)
          return InkWell(
            onTap: () {
              createDio().post('/auth/send_code/',
                  data: {
                    "phone_number": '${arguments["raw"]}',
                  },
                  options: Options(headers: {}));
              controller.restart();
              controller.start();
            },
            child: Text(
              'Запросить код',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          );
        return Container(
          width: 229,
          child: Text(
            'Запросить код повторно через ${time.seconds.inSeconds} сек.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        );
      },
      interval: Duration(milliseconds: 100),
    );
  }
}
