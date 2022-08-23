import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData;
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:image_picker/image_picker.dart';

class AddEditArticleScreen extends StatefulWidget {
  AddEditArticleScreen({Key? key}) : super(key: key);

  @override
  State<AddEditArticleScreen> createState() => _AddEditArticleScreenState();
}

class _AddEditArticleScreenState extends State<AddEditArticleScreen> {
  TextEditingController name =
      TextEditingController(text: Get.arguments?.purpose ?? '');
  TextEditingController description =
      TextEditingController(text: Get.arguments?.description ?? '');
  TextEditingController order =
      TextEditingController(text: '${Get.arguments?.order ?? ''}');
  final ImagePicker _picker = ImagePicker();
  List<MyFile> images = [];
  File? cover;
  ArticleType? item = Get.arguments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (item != null && item!.photos.isNotEmpty) {
        List<MyFile> newImages = [];
        for (var e in item!.photos) {
          Uint8List bytes =
              (await NetworkAssetBundle(Uri.parse(e["image"])).load(e["image"]))
                  .buffer
                  .asUint8List();
          newImages.add(MyFile(bytes: bytes, id: e["id"].toString()));
          // newImages.add(File.fromRawPath(bytes));
        }
        ;
        setState(() {
          images = newImages;
        });
      }
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<Articles>(context).getNews(articleId);
    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      bottomNavigationBar: BottomPanel(
        child: BrandButton(
          text: '${item != null ? 'Сохранить' : 'Опубликовать'}',
          onPressed: () async {
            if (item != null) {
              List photos = [];
              for (var e in images) {
                print('${e.id}   ${e.file} ${e.bytes}');
                if (e.file != null) {
                  var value = await e.file!;
                  photos.add({e.id: e.isModified ? '' : 'o'});
                } else {
                  photos.add({e.id: e.isModified ? '' : 'o'});
                }
              }
              ;
              FormData newPhotos =
                  FormData.fromMap({for (var e in photos) e.key: e.value});
              var data = {
                "title": name.text,
                "description": description.text,
                "order": order.text,
                "photos": newPhotos
              };
              log(photos.toString());
              createDio().patch(
                '/news/${item!.id}/',
                data: data,
              );
            } else {
              Map newPhotos = {};
              newPhotos.addEntries(images.map((e) {
                if (e.file != null) {
                  return MapEntry(
                      e.id,
                      e.isModified
                          ? base64Encode(e.file!.readAsBytesSync())
                          : 'o');
                }
                if (e.bytes != null) {
                  return MapEntry(
                      e.id, e.isModified ? base64Encode(e.bytes!) : 'o');
                }
                return MapEntry(
                    e.id,
                    e.isModified
                        ? base64Encode(e.bytes != null
                            ? e.bytes!
                            : e.file!.readAsBytesSync())
                        : 'o');
              }));
              var data = {
                "title": name.text,
                "description": description.text,
                "order": order.text,
                "photos": newPhotos
              };
              createDio().post('/news/', data: data);
            }
          },
        ),
      ),
      appBar: AppHeader(
        text: '${item != null ? 'Редактирование' : 'Создание'} новости',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Введите название',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                SizedBox(
                  height: 24,
                ),
                Input(
                  label: 'Название',
                  controller: name,
                ),
                SizedBox(
                  height: 32,
                ),
                Text(
                  'Введите описание',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                SizedBox(
                  height: 24,
                ),
                Input(
                  label: 'Описание',
                  controller: description,
                ),
                SizedBox(
                  height: 32,
                ),
                Text(
                  'Выберите обложку',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      cover = null;
                    });
                    //  TODO
                  },
                  onTap: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      cover = File(image!.path);
                    });
                  },
                  child: Container(
                    height: 132,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Color(0xFFFBF7F7),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: cover != null
                          ? Image.file(
                              cover!,
                              height: 132,
                              width: double.maxFinite,
                            )
                          : item?.cover != null
                              ? Image.network(
                                  item?.cover,
                                  fit: BoxFit.cover,
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 133, vertical: 28),
                                  child: BrandIcon(
                                    icon: 'upload',
                                    color: Color(0xFFE1D6D6),
                                  ),
                                ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Text(
                  'Выберите фоторафии',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            height: 132,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  // images.length < 3
                  //     ?

                  //  добавление

                  GestureDetector(
                    onTap: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        var newImages = [...images];
                        newImages.add(MyFile(
                            file: File(image.path),
                            id: generateRandomString(10),
                            isModified: true));
                        setState(() {
                          images = newImages;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 16, left: 16),
                      height: 132,
                      width: 132,
                      decoration: BoxDecoration(
                          color: Color(0xFFFBF7F7),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: BrandIcon(
                          icon: 'plus',
                          height: 36,
                          width: 36,
                          color: Color(0xFFE1D6D6),
                        ),
                      ),
                    ),
                  ),
                  // : Container(),
                  ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length < 1 ? 0 : images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          var newImages = [...images];
                          newImages.remove(newImages[index]);
                          setState(() {
                            images = newImages;
                          });
                        },
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            List<MyFile> newImages = [...images];
                            // Замена
                            newImages[index] = MyFile(
                                file: File(image.path),
                                id: images[index].id,
                                isModified: true);
                            setState(() {
                              images = newImages;
                            });
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: 16),
                            height: 132,
                            width: 132,
                            decoration: BoxDecoration(
                                color: Color(0xFFFBF7F7),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: images.isEmpty ||
                                    !images.asMap().containsKey(index)
                                ? null
                                : images[index].bytes != null
                                    ? Image.memory(
                                        images[index].bytes!,
                                      )
                                    : Image.file(images[index].file!)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32,
                ),
                Text(
                  'Введите порядковый номер',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                SizedBox(
                  height: 24,
                ),
                Input(
                  label: 'Номер (1, 2, 3 и т.п.)',
                  controller: order,
                ),
                SizedBox(
                  height: 29,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyFile {
  final String id;
  final Uint8List? bytes;
  final File? file;
  bool isModified;
  void modify() {
    this.isModified = true;
  }

  MyFile({required this.id, this.bytes, this.file, this.isModified = false});
}
