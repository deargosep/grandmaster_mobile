import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';

class FailScreen extends StatelessWidget {
  const FailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppHeader(
          text: '',
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BrandIcon(
                icon: 'x',
                color: Color(0xFFFF3737),
                height: 75,
                width: 75,
              ),
              SizedBox(
                height: 73,
              ),
              Container(
                width: 303,
                child: Text(
                  Get.arguments,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
            ],
          ),
        ));
  }
}
