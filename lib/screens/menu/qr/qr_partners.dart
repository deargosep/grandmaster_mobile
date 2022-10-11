import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';

import '../../../utils/dio.dart';

class QRPartners extends StatefulWidget {
  const QRPartners({Key? key}) : super(key: key);

  @override
  State<QRPartners> createState() => _QRPartnersState();
}

class _QRPartnersState extends State<QRPartners> {
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
      setState(() {
        image = decoded;
        isLoaded = true;
      });
    } else {
      createDio().get('/qrcodes/for_partners/').then((value2) {
        var data = value2.data["data"];
        String imageEncoded = data;
        String decoded = Utf8Decoder()
            .convert(base64Decode(imageEncoded))
            .replaceAll('mm', '')
            .replaceAll(
                '<path ', '<path shape-rendering="geometricPrecision" ');
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
          text: 'Для партнеров',
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
