import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/images/logo.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map numbers = {
  "parent": '+7 (918) 546-85-81',
  "child": '+7 (928) 900-06-80',
  "moderator": "+7 (900) 133-78-68",
  "trainer": "+7 (938) 115-54-47",
  "payment": "+7 (900) 126-16-92"
};

class AuthRegisterScreen extends StatefulWidget {
  const AuthRegisterScreen({Key? key}) : super(key: key);

  @override
  State<AuthRegisterScreen> createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> {
  TextEditingController phoneNumber = TextEditingController(
      // text: '+'
      text: numbers["moderator"]);
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoaded = false;
    });
    SharedPreferences.getInstance().then((sp) {
      if (sp.getString('access') != null) {
        createDio(errHandler: (DioError err, handler) {
          setState(() {
            isLoaded = true;
          });
        })
            .get(
          '/users/self/',
        )
            .then((value) {
          if (value.statusCode == 200) {
            Provider.of<UserState>(context, listen: false).setUser(value.data);
            Get.offAllNamed('/bar', arguments: 1);
          }
        });
      } else {
        setState(() {
          isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // void onChanged(String text) {
    //   // if (text == '7') phoneNumber.text = '+$text';
    //   // if (text == '8') phoneNumber.text = '+7';
    // }

    if (!isLoaded)
      return CustomScaffold(
          noPadding: false,
          body: Center(
            child: Logo(),
          ));
    return CustomScaffold(
        noPadding: false,
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
            InputPhone(
              label: 'Номер телефона',
              controller: phoneNumber,
              // onChanged: onChanged,
            ),
            Spacer(),
            BrandButton(
                text: 'Продолжить',
                type: 'primary',
                onPressed: () {
                  SharedPreferences.getInstance()
                      .then((value) => value.clear());
                  var number = phoneNumber.text
                      .replaceAll(' ', '')
                      .replaceAll(')', '')
                      .replaceAll('(', '')
                      .replaceAll('-', '');
                  createDio()
                      .post('/auth/send_code/',
                          data: {
                            "phone_number": number,
                          },
                          options: Options(headers: {}))
                      .then((value) => Get.toNamed('/code', arguments: number));
                }),
            SizedBox(
              height: 16,
            ),
            BrandButton(
                onPressed: () {
                  Provider.of<UserState>(context, listen: false)
                      .setUserCustom(User(role: 'guest', passport: Passport()));
                  Get.offAllNamed('/bar', arguments: 1);
                },
                text: 'Войти как гость',
                type: 'secondary'),
          ],
        ));
  }
}
