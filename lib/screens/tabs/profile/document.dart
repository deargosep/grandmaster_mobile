import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import '../../../state/user.dart';
import '../../../utils/dio.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  Map arguments = Get.arguments;
  Map<String, dynamic> documents = Map.from(Get.arguments["documents"] ?? {});
  User user = Get.arguments["user"];
  int currentIndex = 0;
  CarouselController controller = CarouselController();
  bool photoLoaded = false;

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
  void initState() {
    super.initState();
    if (arguments["type"] != 'other') currentIndex = arguments["index"];
    if (user.role == 'trainer')
      optionList = [
        {
          "title": 'Паспорт / Свидетельство о рождении',
          "code": "passport_or_birth_certificate"
        },
        {"title": 'Полис ОМС', "code": "oms_policy"},
        {"title": 'Страховой полис', "code": "insurance_policy"},
        {
          "title": 'Диплом о технической квалификации',
          "code": "tech_qual_diplo"
        },
        {"title": 'Загранпаспорт', "code": "foreign_passport"},
        {"title": 'ИНН', "code": "inn"},
        {"title": 'Диплом об образовании', "code": "diploma"},
        {"title": 'СНИЛС', "code": "snils"},
      ];
  }

  @override
  Widget build(BuildContext context) {
    if (arguments["type"] == 'other') {
      return FutureBuilder<Response>(
          future: createDio().get(user.documentsUrl!),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return CustomScaffold(
                  appBar: AppHeader(
                    text: "Другие документы",
                  ),
                  body: Center(child: CircularProgressIndicator()));
            List other_documents = snapshot.data?.data["other_documents"];
            if (other_documents.isEmpty)
              return CustomScaffold(
                  appBar: AppHeader(
                    text: "Другие документы",
                  ),
                  body: Center(
                    child: Text('Нет других документов'),
                  ));
            return CustomScaffold(
                noHorPadding: true,
                noPadding: false,
                appBar: AppHeader(
                    text: "Другие документы",
                    icon: 'download',
                    iconOnTap: () async {
                      String rawUrl = other_documents[currentIndex];
                      Uri url = Uri.parse(rawUrl);
                      if (kIsWeb) {
                        try {
                          // first we make a request to the url like you did
                          // in the android and ios version
                          final http.Response r = await http.get(url);

                          // we get the bytes from the body
                          final data = r.bodyBytes;
                          // and encode them to base64
                          final base64data = base64Encode(data);
                          html.AnchorElement anchorElement =
                              new html.AnchorElement(
                                  href: 'data:image/jpeg;base64,$base64data');
                          anchorElement.download =
                              "other_document${currentIndex}";
                          anchorElement.click();
                          anchorElement.remove();
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    }),
                body: Center(
                    child: CarouselSlider(
                  carouselController: controller,
                  options: CarouselOptions(
                    onPageChanged: (ind, CarouselPageChangedReason reason) {
                      if (mounted)
                        setState(() {
                          currentIndex = ind;
                        });
                    },
                    initialPage: 0,
                    viewportFraction: 1,
                    height: 335.0,
                    enableInfiniteScroll: false,
                  ),
                  items: other_documents.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            if (i != null)
                              Get.toNamed(
                                  '/my_profile/documents/document/watch',
                                  arguments: i);
                          },
                          child: Container(
                            height: 335,
                            width: 335,
                            decoration: BoxDecoration(
                                color: Color(0xFFEFEFEF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: i != null
                                ? LoadingImage(
                                    i,
                                    height: 335,
                                    width: 335,
                                  )
                                : Center(
                                    child: Text(
                                    "Нет документа",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )));
          });
    }
    return CustomScaffold(
        noHorPadding: true,
        noPadding: false,
        appBar: AppHeader(
          text: optionList[currentIndex]["title"],
          icon: documents[optionList[currentIndex]["code"]] != null
              ? 'download'
              : '',
          iconDisabled: !photoLoaded,
          iconOnTap: () async {
            String rawUrl = documents[optionList[currentIndex]["code"]];
            Uri url = Uri.parse(rawUrl);
            if (kIsWeb) {
              try {
                // first we make a request to the url like you did
                // in the android and ios version
                final http.Response r = await http.get(url);

                // we get the bytes from the body
                final data = r.bodyBytes;
                // and encode them to base64
                final base64data = base64Encode(data);
                html.AnchorElement anchorElement = new html.AnchorElement(
                    href: 'data:image/jpeg;base64,$base64data');
                anchorElement.download =
                    "document_${optionList[currentIndex]["code"]}";
                anchorElement.click();
                anchorElement.remove();
              } catch (e) {
                print(e);
              }
            } else {
              await launchUrl(
                  Uri.parse(documents[optionList[currentIndex]["code"]]),
                  mode: LaunchMode.externalApplication);
            }
          },
        ),
        body: Center(
            child: CarouselSlider(
          carouselController: controller,
          options: CarouselOptions(
            onPageChanged: (ind, CarouselPageChangedReason reason) {
              if (mounted)
                setState(() {
                  photoLoaded = false;
                  currentIndex = ind;
                });
            },
            initialPage: arguments["index"],
            viewportFraction: 1,
            height: 335.0,
            enableInfiniteScroll: false,
          ),
          items: optionList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    if (documents[i["code"]] != null)
                      Get.toNamed('/my_profile/documents/document/watch',
                          arguments: documents[i["code"]]);
                  },
                  child: Container(
                      height: 335,
                      width: 335,
                      decoration: BoxDecoration(
                          color: Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: documents[i["code"]] != null
                          ? LoadingImage(
                              documents[i["code"]]!,
                              height: 335,
                              width: 335,
                              onLoad: () {
                                if (mounted)
                                  setState(() {
                                    photoLoaded = true;
                                  });
                              },
                            )
                          : Center(
                              child: Text(
                              "Нет документа",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ))),
                );
              },
            );
          }).toList(),
        )));
  }
}
