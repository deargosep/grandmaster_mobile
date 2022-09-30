import 'package:flutter/material.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

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
    if (Provider.of<UserState>(context, listen: false)
        .user
        .children
        .isNotEmpty) {
      // createDio().get('/qrcodes/for_partners/?id=${}')
      setState(() {
        list = [
          ...Provider.of<UserState>(context, listen: false)
              .user
              .children
              .map((e) => OptionType(
                    e.fullName,
                    '/qr/child',
                    arguments: e.id,
                  ))
              .toList()
        ];
      });
      // list = [
      //   OptionType('Для мероприятий', '/qr/events', arguments: data2),
      //   OptionType('Для партнёров', '/qr/partners', arguments: data1),
      // ];
      // });
    } else {
      // createDio().get('/qrcodes/for_partners/').then((value1) {
      //   var data1 = value1.data["data"];
      //   createDio().get('/qrcodes/for_events/').then((value2) {
      //     var data2 = value2.data["data"];
      setState(() {
        list = [
          OptionType(
            'Для мероприятий',
            '/qr/events',
          ),
          OptionType(
            'Для партнёров',
            '/qr/partners',
          ),
        ];
      });
      // });
      // });
    }
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
