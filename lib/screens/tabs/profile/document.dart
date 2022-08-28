import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../state/user.dart';
import '../../../utils/dio.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final initialIndex = Get.arguments;
  int currentIndex = 0;
  CarouselController controller = CarouselController();

  @override
  void initState() {
    super.initState();
    currentIndex = initialIndex;
  }

  List<Map> optionList = [
    {
      "title": 'Паспорт / Свидетельство о рождении',
      "code": "passport_or_birth_certificate"
    },
    {"title": 'Полис ОМС', "code": "oms_policy"},
    {"title": 'Справка из школы', "code": "school_ref"},
    {"title": 'Страховой полис', "code": "insurance_policy"},
    {"title": 'Диплом о технической квалификации', "code": "tech_qual_diplo"},
    {"title": 'Медицинская справка', "code": "med_certificate"},
    {"title": 'Загранпаспорт', "code": "foreign_passport"},
    {"title": 'ИНН', "code": "inn"},
    {"title": 'Диплом об образовании', "code": "diploma"},
    {"title": 'СНИЛС', "code": "snils"},
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
        future: createDio().get(
            Provider.of<UserState>(context, listen: false).user.documentsUrl!),
        builder: (context, snapshot) {
          return CustomScaffold(
              noHorPadding: true,
              noPadding: false,
              appBar: AppHeader(
                text: optionList[currentIndex]["title"],
              ),
              body: Center(
                  child: CarouselSlider(
                carouselController: controller,
                options: CarouselOptions(
                  onPageChanged: (ind, CarouselPageChangedReason reason) {
                    setState(() {
                      currentIndex = ind;
                    });
                  },
                  initialPage: initialIndex,
                  viewportFraction: 1,
                  height: 335.0,
                  enableInfiniteScroll: false,
                ),
                items: optionList.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        height: 335,
                        width: 335,
                        decoration: BoxDecoration(
                            color: Color(0xFFEFEFEF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: snapshot.data?.data[i["code"]] != null
                            ? Image.network(snapshot.data?.data[i["code"]])
                            : Center(
                                child: Text(
                                "Нет документа",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )),
                      );
                    },
                  );
                }).toList(),
              )));
        });
  }
}
