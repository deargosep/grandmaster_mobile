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
  "parent": '(918) 546-85-81',
  "child": '(918) 5528722',
  "moderator": "(909) 283-21-21",
  "trainer": "(988) 250-30-03",
  "payment": "(900) 126-16-92",
  "documents": "(900) 123-09-56",
  "schedule": "(938) 115-54-47",
  "parent_chats": '(928) 111-02-00',
  "other_documents": '(928) 601-66-92',
  "specialist": '(928) 270-13-53'
};

class AuthRegisterScreen extends StatefulWidget {
  const AuthRegisterScreen({Key? key}) : super(key: key);

  @override
  State<AuthRegisterScreen> createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> {
  TextEditingController phoneNumber =
      TextEditingController(text: numbers["payment"]);
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoaded = false;
    });
    phoneNumber.addListener(() {
      String myText = phoneNumber.text;
      if (myText.length > 2) {
        print('${myText[1]} test');
        if (myText[1] == '8') {
          myText.replaceAll('8', '7');
          phoneNumber.text = '${myText}';
          phoneNumber.selection = TextSelection.fromPosition(
              TextPosition(offset: phoneNumber.text.length));
          print(myText);
        }
      }
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

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              // onChanged: onChanged,
            ),
            Spacer(),
            BrandButton(
                text: 'Продолжить',
                type: 'primary',
                // disabled: _formKey.currentState != null
                //     ? !_formKey.currentState!.validate()
                //     : true,
                onPressed: () {
                  if (phoneNumber.text.length == "(###) ###-##-##".length) {
                    SharedPreferences.getInstance()
                        .then((value) => value.clear());
                    var number = '+7 ${phoneNumber.text}'
                        .replaceAll(' ', '')
                        .replaceAll(')', '')
                        .replaceAll('(', '')
                        .replaceAll('-', '');
                    createDio()
                        .post('/auth/send_code/',
                            data: {
                              "phone_number": '${number}',
                            },
                            options: Options(headers: {}))
                        .then((value) => Get.toNamed('/code', arguments: {
                              "formatted": '+7 ${phoneNumber.text}',
                              "raw": number
                            }));
                  }
                }),
            Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  BrandButton(
                    onPressed: () {
                      Provider.of<UserState>(context, listen: false)
                          .setUserCustom(
                              User(role: 'guest', passport: Passport()));
                      Get.offAllNamed('/bar', arguments: 1);
                    },
                    text: 'Войти как гость',
                    type: 'secondary',
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
