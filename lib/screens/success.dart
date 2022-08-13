import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

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
                icon: 'check',
                color: Color(0xFF76FF60),
                height: 50,
                width: 66,
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
