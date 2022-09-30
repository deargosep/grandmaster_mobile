import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';

class QRChildScreen extends StatefulWidget {
  const QRChildScreen({Key? key}) : super(key: key);

  @override
  State<QRChildScreen> createState() => _QRChildScreenState();
}

class _QRChildScreenState extends State<QRChildScreen> {
  List<OptionType> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDio()
        .get('/qrcodes/for_partners/?id=${Get.arguments}')
        .then((value1) {
      var data1 = value1.data["data"];
      createDio()
          .get('/qrcodes/for_events/?id=${Get.arguments}')
          .then((value2) {
        var data2 = value2.data["data"];
        setState(() {
          list = [
            OptionType('Для мероприятий', '/qr/events', arguments: data2),
            OptionType('Для партнёров', '/qr/partners', arguments: data1),
          ];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        noPadding: false,
        noTopPadding: true,
        appBar: AppHeader(
          text: 'QR коды',
        ),
        body: list.isNotEmpty
            ? ListOfOptions(list: list)
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
