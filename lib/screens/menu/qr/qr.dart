import 'package:flutter/material.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  List<OptionType> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDio().get('/qrcodes/for_partners/').then((value1) {
      var data1 = value1.data["data"];
      createDio().get('/qrcodes/for_events/').then((value2) {
        var data2 = value2.data["data"];
        print('${data1},${data2}');
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
        appBar: AppHeader(
          text: 'QR коды',
        ),
        body: ListOfOptions(list: list));
  }
}
