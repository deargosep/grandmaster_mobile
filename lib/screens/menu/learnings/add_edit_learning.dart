import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/learnings.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:provider/provider.dart';

import '../../../utils/dio.dart';

class AddEditLearningScreen extends StatefulWidget {
  AddEditLearningScreen({Key? key}) : super(key: key);

  @override
  State<AddEditLearningScreen> createState() => _AddEditLearningScreenState();
}

class _AddEditLearningScreenState extends State<AddEditLearningScreen> {
  TextEditingController name =
      TextEditingController(text: Get.arguments?.name ?? '');
  TextEditingController description =
      TextEditingController(text: Get.arguments?.description ?? '');
  TextEditingController link =
      TextEditingController(text: Get.arguments?.link ?? '');
  TextEditingController order =
      TextEditingController(text: Get.arguments?.order.toString() ?? '');
  LearningType? item = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      bottomNavigationBar: BottomPanel(
        withShadow: false,
        child: BrandButton(
          text: item != null ? 'Сохранить' : 'Опубликовать',
          onPressed: () {
            Map data = {
              "title": name.text,
              "description": description.text,
              "link": link.text,
              "order": order.text
            };
            if (item != null) {
              if (item?.name == name.text) data.remove('title');
              if (item?.description == description.text)
                data.remove('description');
              if (item?.link == link.text) data.remove('link');
              if (item?.order == order.text) data.remove('order');
              createDio()
                  .patch(
                '/instructions/${item?.id}/',
                data: data,
              )
                  .then((value) {
                Provider.of<LearningsState>(context, listen: false)
                    .setLearnings();
                Get.back();
              });
            } else {
              createDio()
                  .post(
                '/instructions/',
                data: data,
              )
                  .then((value) {
                Provider.of<LearningsState>(context, listen: false)
                    .setLearnings();
                Get.back();
              });
            }
          },
        ),
      ),
      appBar: AppHeader(
        text: item != null ? 'Редактирование записи' : 'Создание материала',
      ),
      body: Padding(
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
              'Введите ссылку на документ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 24,
            ),
            Input(
              label: 'Ссылка',
              controller: link,
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
            )
          ],
        ),
      ),
    );
  }
}
