import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:grandmaster/state/about.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEditAboutScreen extends StatefulWidget {
  AddEditAboutScreen({Key? key}) : super(key: key);

  @override
  State<AddEditAboutScreen> createState() => _AddEditAboutScreenState();
}

class _AddEditAboutScreenState extends State<AddEditAboutScreen> {
  final ImagePicker _picker = ImagePicker();
  File? cover;
  AboutType? item = Get.arguments;
  TextEditingController name =
      TextEditingController(text: Get.arguments?.name ?? '');
  TextEditingController description =
      TextEditingController(text: Get.arguments?.description ?? '');
  TextEditingController order =
      TextEditingController(text: Get.arguments?.order.toString() ?? '');

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      appBar: AppHeader(
        text: '${item != null ? 'Редактирование' : 'Создание'} контента',
      ),
      bottomNavigationBar: BottomPanel(
        withShadow: false,
        child: BrandButton(
          text: 'Далее',
          onPressed: () async {
            Map<String, dynamic> data = {
              "name": name.text,
              "description": description.text,
              "order": order.text,
              "hidden": false
            };
            FormData formData = FormData.fromMap(data);
            if (cover != null) {
              formData = await getFormFromFile(cover!, 'cover', data);
            }
            if (item != null) {
              createDio()
                  .patch('/club_content/${item?.id}/',
                      data: formData,
                      options: Options(contentType: 'multipart/form-data'))
                  .then((value) {
                Get.back();
                Provider.of<AboutState>(context, listen: false).setAbout();
              });
            } else {
              createDio()
                  .post('/club_content/${item?.id}/',
                      data: formData,
                      options: Options(contentType: 'multipart/form-data'))
                  .then((value) {
                Get.back();
                Provider.of<AboutState>(context, listen: false).setAbout();
              });
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                    : item?.cover != null
                        ? Image.network(item?.cover)
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
          ],
        ),
      ),
    );
  }
}
