import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:image_picker/image_picker.dart';

class AddAboutScreen extends StatefulWidget {
  AddAboutScreen({Key? key}) : super(key: key);

  @override
  State<AddAboutScreen> createState() => _AddAboutScreenState();
}

class _AddAboutScreenState extends State<AddAboutScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File?> images = [];
  File? cover;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      appBar: AppHeader(
        text: 'Создание контента',
      ),
      bottomNavigationBar: BottomPanel(
        withShadow: false,
        child: BrandButton(
          text: 'Далее',
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 133, vertical: 28),
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
            ),
          ],
        ),
      ),
    );
  }
}
