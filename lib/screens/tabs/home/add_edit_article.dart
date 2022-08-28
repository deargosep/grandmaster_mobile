import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEditArticleScreen extends StatefulWidget {
  AddEditArticleScreen({Key? key}) : super(key: key);

  @override
  State<AddEditArticleScreen> createState() => _AddEditArticleScreenState();
}

class _AddEditArticleScreenState extends State<AddEditArticleScreen> {
  TextEditingController name =
      TextEditingController(text: Get.arguments?.name ?? '');
  TextEditingController description =
      TextEditingController(text: Get.arguments?.description ?? '');
  TextEditingController order =
      TextEditingController(text: '${Get.arguments?.order ?? ''}');
  final ImagePicker _picker = ImagePicker();
  List<MyFile> images = [];
  File? cover;
  XFile? xCover;
  String? coverPath;
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

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
              if (_formKey.currentState != null) if (_formKey.currentState!
                  .validate()) {
                Map<String, dynamic> data = {
                  "title": name.text,
                  "description": description.text,
                  "order": order.text,
                  "hidden": false
                };
                if (cover != null) {
                  var coverfile = !kIsWeb
                      ? await MultipartFile.fromFile(cover!.path)
                      : await MultipartFile.fromBytes(
                          await xCover!.readAsBytes(),
                          filename:
                              xCover!.name.substring(xCover!.name.length - 8));
                  data.addAll({"cover": coverfile});
                }
                Future<List<Map<String, dynamic>>> getList() async {
                  List<Map<String, dynamic>> list = [];
                  for (var e in images) {
                    var file;
                    if (!kIsWeb) {
                      if (e.file == null) {
                        list.add({
                          "id": e.id,
                          "file": "jn",
                          "isModified": e.isModified
                        });
                      } else {
                        file = await MultipartFile.fromFile(
                          e.file!.path,
                        );

                        list.add({
                          "file": file,
                          "id": e.id,
                          "isModified": e.isModified
                        });
                      }
                    } else {
                      if (e.pickedFile == null) {
                        list.add({
                          "id": e.id,
                          "file": "jn",
                          "isModified": e.isModified
                        });
                      } else {
                        file = await MultipartFile.fromBytes(
                            await e.pickedFile!.readAsBytes(),
                            filename: e.pickedFile!.name
                                .substring((e.pickedFile!.name.length - 8)));

                        list.add({
                          "file": file,
                          "id": e.id,
                          "isModified": e.isModified
                        });
                      }
                    }
                  }
                  return list;
                }

                List<Map<String, dynamic>> photosL = await getList();
                Iterable<MapEntry<String, dynamic>> photos = photosL.map((e) {
                  return MapEntry(
                      item?.photos.firstWhereOrNull(
                                  (element) => element["id"] == e["id"]) !=
                              null
                          ? generateRandomString(5)
                          : e["id"],
                      e["isModified"] ? e["file"] : 'o');
                });
                data.addEntries(photos);
                FormData newData = FormData.fromMap(data);
                if (item != null) {
                  print(newData.fields);
                  print(newData.files);
                  createDio()
                      .patch('/news/${item!.id}/',
                          data: newData,
                          options: Options(contentType: 'multipart/form-data'))
                      .then((value) {
                    Get.back();
                    Provider.of<Articles>(context, listen: false).setNews();
                  });
                } else {
                  createDio()
                      .post('/news/',
                          data: newData,
                          options: Options(contentType: 'multipart/form-data'))
                      .then((value) {
                    Get.back();
                    Provider.of<Articles>(context, listen: false).setNews();
                  });
                }
              }
            }),
      ),
      appBar: AppHeader(
        text: '${item != null ? 'Редактирование' : 'Создание'} новости',
      ),
      body: Form(
        key: _formKey,
        child: Column(
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
                    behavior: HitTestBehavior.translucent,
                    onLongPress: () {
                      setState(() {
                        cover = null;
                      });
                      //  TODO
                    },
                    onTap: () async {
                      final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 60);
                      setState(() {
                        cover = File(image!.path);
                        xCover = image;
                        coverPath = image.path;
                      });
                    },
                    child: Container(
                      height: 132,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFFBF7F7),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: cover != null
                            ? !kIsWeb
                                ? Image.file(
                                    cover!,
                                    height: 132,
                                    width: double.maxFinite,
                                  )
                                : Image.network(coverPath!)
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
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 60);
                        if (image != null) {
                          var newImages = [...images];
                          newImages.add(MyFile(
                              path: image.path,
                              pickedFile: image,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
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
                                source: ImageSource.gallery, imageQuality: 60);
                            if (image != null) {
                              List<MyFile> newImages = [...images];
                              // Замена
                              newImages[index] = MyFile(
                                  pickedFile: image,
                                  path: image.path,
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
                                      : !kIsWeb
                                          ? Image.file(images[index].file!)
                                          : Image.network(images[index].path!)),
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
      ),
    );
  }
}

class MyFile {
  final String id;
  final Uint8List? bytes;
  final File? file;
  final XFile? pickedFile;
  final String? path;
  bool isModified;
  void modify() {
    this.isModified = true;
  }

  MyFile(
      {this.path,
      this.pickedFile,
      required this.id,
      this.bytes,
      this.file,
      this.isModified = false});
}
