import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';

import '../../../utils/dio.dart';

class QREvents extends StatefulWidget {
  const QREvents({Key? key}) : super(key: key);

  @override
  State<QREvents> createState() => _QREventsState();
}

class _QREventsState extends State<QREvents> {
  var image;
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      String imageEncoded = Get.arguments;
      String decoded = Utf8Decoder()
          .convert(base64Decode(imageEncoded))
          .replaceAll('mm', '')
          .replaceAll('<path ', '<path shape-rendering="geometricPrecision" ');
      print(decoded);
      setState(() {
        image = decoded;
        isLoaded = true;
      });
    } else {
      createDio().get('/qrcodes/for_events/').then((value1) {
        var data = value1.data["data"];
        String imageEncoded = data;
        String decoded = Utf8Decoder()
            .convert(base64Decode(imageEncoded))
            .replaceAll('mm', '')
            .replaceAll(
                '<path ', '<path shape-rendering="geometricPrecision" ');
        print(decoded);
        setState(() {
          image = decoded;
          isLoaded = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppHeader(
          text: 'Для мероприятий',
        ),
        body: isLoaded
            ? SvgPicture.string(
                image,
                height: 313,
                width: 313,
              )
            : CircularProgressIndicator());
  }
}
