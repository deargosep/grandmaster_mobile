import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';

import '../state/user.dart';

class SomeoneProfile extends StatelessWidget {
  const SomeoneProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Get.arguments;
    return Scaffold(
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
                    Container(height: 136, width: 136, child: CircleAvatar()),
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
                      onTap: () {},
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
