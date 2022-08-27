import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';

class QREvents extends StatefulWidget {
  const QREvents({Key? key}) : super(key: key);

  @override
  State<QREvents> createState() => _QREventsState();
}

class _QREventsState extends State<QREvents> {
  var image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String imageEncoded = Get.arguments;
    String decoded = Utf8Decoder()
        .convert(base64Decode(imageEncoded))
        .replaceAll('mm', '')
        .replaceAll('<path ', '<path shape-rendering="geometricPrecision" ');
    print(decoded);
    setState(() {
      image = decoded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppHeader(
          text: 'Для мероприятий',
        ),
        body: SvgPicture.string(
          image,
          height: 313,
          width: 313,
        ));
  }
}
