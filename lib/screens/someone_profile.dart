import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:provider/provider.dart';

import '../state/user.dart';
import '../utils/custom_scaffold.dart';

class SomeoneProfile extends StatelessWidget {
  const SomeoneProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    User user = Get.arguments;
    return CustomScaffold(
      body: Container(
        padding: EdgeInsets.only(top: 32, left: 20, right: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 28,
              child: BrandIcon(
                icon: 'back_arrow',
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Positioned(
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Container(
                        height: 136,
                        width: 136,
                        child: user.photo != null
                            ? Avatar(
                                user.photo!,
                                height: 136,
                                width: 136,
                              )
                            : Container()),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      user.fullName,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 33,
                    ),
                    GestureDetector(
                      onTap: () {
                        createDio().get('/chats/${user.chatId}/').then((value) {
                          print(value.data);
                          Provider.of<ChatsState>(context, listen: false)
                              .setChats()
                              .then((value) {
                            Get.toNamed('/chat',
                                arguments: Provider.of<ChatsState>(context,
                                        listen: false)
                                    .chats
                                    .firstWhere((element) =>
                                        element.id == user.chatId));
                          });
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 281,
                        decoration: BoxDecoration(
                            color: Color(0xFFFBF7F7),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Center(
                          child: Text(
                            'Написать сообщение',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
