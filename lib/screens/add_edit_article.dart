import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/news.dart';
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
  final ImagePicker _picker = ImagePicker();
  List<File?> images = [];
  File? cover;
  var articleId = Get.arguments;
  @override
  Widget build(BuildContext context) {
    ArticleType? article = Provider.of<Articles>(context).getNews(articleId);
    return Scaffold(
      appBar: AppHeader(
        text: '${articleId != null ? 'Редактирование' : 'Создание'} новости',
      ),
      body: SingleChildScrollView(
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
                    defaultText: "${article != null ? article.name : ""}",
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
                    defaultText:
                        "${article != null ? article.description : ""}",
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
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: cover != null
                          ? Image.file(
                              cover!,
                              height: 132,
                              width: double.maxFinite,
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
                    images.length < 3
                        ? GestureDetector(
                            onTap: () async {
                              final XFile? image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              var newImages = [...images];
                              newImages.add(File(image!.path));
                              setState(() {
                                images = newImages;
                              });
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
                          )
                        : Container(),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
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
                            var newImages = [...images];
                            newImages[index] = File(image!.path);
                            setState(() {
                              images = newImages;
                            });
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
                                  : Image.file(images[index]!)),
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
                    defaultText: "${article != null ? article.id : ""}",
                  ),
                  SizedBox(
                    height: 98,
                  ),
                  BrandButton(
                    text: '${articleId != null ? 'Сохранить' : 'Опубликовать'}',
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
