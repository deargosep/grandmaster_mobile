import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
  "child": '(918) 552-87-22',
  "moderator": "(931) 963-10-29",
  "trainer": "(988) 250-30-03",
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
      TextEditingController(text: kDebugMode ? numbers["trainer"] : '');
  bool isLoaded = false;
  bool isLoadedAuth = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoaded = false;
    });
    SharedPreferences.getInstance().then((sp) async {
      if (!kIsWeb) {
        FirebaseMessaging messaging = FirebaseMessaging.instance;

        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        print('User granted permission: ${settings.authorizationStatus}');
      }
      if (sp.getString('access') != null) {
        createDio(errHandler: (DioError err, handler) {
          if (err.response?.data["code"] == 'token_not_valid') {
            try {
              createDio()
                  .post('/auth/token/refresh/',
                      data: {"refresh": sp.getString('refresh')},
                      options: Options(headers: {"Authorization": null}))
                  .then((value) {
                sp.setString('access', value.data["access"]);
                sp.setString('refresh', value.data["refresh"]).then((value) {
                  createDio().get('/users/self/').then((value) {
                    if (isValidContactType(value.data["contact_type"])) {
                      FlutterNativeSplash.remove();
                      setState(() {
                        isLoaded = true;
                      });
                      Get.offAllNamed('/bar', arguments: 1);
                    }
                  });
                });
              });
            } catch (e) {
              FlutterNativeSplash.remove();
              setState(() {
                isLoaded = true;
              });
            }
          }
          if (err.response?.data["code"] == 'user_inactive') {
            sp.clear();
            FlutterNativeSplash.remove();
            setState(() {
              isLoaded = true;
            });
          }
        })
            .get(
          '/users/self/',
        )
            .then((value) {
          if (value.statusCode == 200) {
            FlutterNativeSplash.remove();
            if (isValidContactType(value.data["contact_type"])) {
              Provider.of<UserState>(context, listen: false)
                  .setUser(value.data);
              Get.offAllNamed('/bar', arguments: 1);
            }
          }
        });
      } else {
        FlutterNativeSplash.remove();
        setState(() {
          isLoaded = true;
        });
      }
    });
  }

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // if (!isLoaded)
    //   return CustomScaffold(
    //       noPadding: false,
    //       body: Center(
    //         child: Logo(),
    //       ));
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
            Form(
              key: _formKey,
              child: InputPhone(
                label: 'Номер телефона',
                controller: phoneNumber,
                // onChanged: onChanged,
                // onChanged: onChanged,
              ),
            ),
            Spacer(),
            BrandButton(
                text: 'Продолжить',
                type: 'primary',
                isLoaded: isLoadedAuth,
                // disabled: _formKey.currentState != null
                //     ? !_formKey.currentState!.validate()
                //     : true,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (mounted)
                      setState(() {
                        isLoadedAuth = false;
                      });
                    SharedPreferences.getInstance()
                        .then((value) => value.clear());
                    var number = '+7 ${phoneNumber.text}'
                        .replaceAll(' ', '')
                        .replaceAll(')', '')
                        .replaceAll('(', '')
                        .replaceAll('-', '');
                    createDio(errHandler: (err, handler) {
                      if (mounted)
                        setState(() {
                          isLoadedAuth = true;
                        });
                    })
                        .post('/auth/send_code/',
                            data: {
                              "phone_number": '${number}',
                            },
                            options: Options(headers: {}))
                        .then((value) {
                      Get.toNamed('/code', arguments: {
                        "formatted": '+7 ${phoneNumber.text}',
                        "raw": number
                      });
                    }).whenComplete(() {
                      if (mounted)
                        setState(() {
                          isLoadedAuth = true;
                        });
                    });
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
