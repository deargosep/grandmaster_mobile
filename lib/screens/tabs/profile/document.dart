import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';

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

  List<String> optionList = [
    'Паспорт / Свидетельство о рождении',
    'Полис ОМС',
    'Справка из школы',
    'Страховой полис',
    'Диплом о технической квалификации',
    'Медицинская справка',
    'Загранпаспорт',
    'ИНН',
    'Диплом об образовании',
    'СНИЛС',
  ];
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        noHorPadding: true,
        appBar: AppHeader(
          text: optionList[currentIndex],
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
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                );
              },
            );
          }).toList(),
        )));
  }
}
