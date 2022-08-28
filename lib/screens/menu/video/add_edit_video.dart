import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/videos.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:provider/provider.dart';

class AddEditVideoScreen extends StatefulWidget {
  AddEditVideoScreen({Key? key}) : super(key: key);

  @override
  State<AddEditVideoScreen> createState() => _AddEditVideoScreenState();
}

class _AddEditVideoScreenState extends State<AddEditVideoScreen> {
  TextEditingController name =
      TextEditingController(text: Get.arguments?.name ?? '');
  TextEditingController link =
      TextEditingController(text: Get.arguments?.link ?? '');
  TextEditingController order =
      TextEditingController(text: Get.arguments?.order.toString() ?? '');
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      bottomNavigationBar: BottomPanel(
        withShadow: false,
        child: BrandButton(
          text: Get.arguments != null ? 'Сохранить' : 'Опубликовать',
          onPressed: () {
            if (_formKey.currentState != null) if (_formKey.currentState!
                .validate()) {
              Map data = {
                "title": name.text,
                "link": link.text,
                "order": order.text
              };
              if (Get.arguments != null) {
                // if (Get.arguments["title"] == name.text) data.remove('title');
                // if (Get.arguments["link"] == link.text) data.remove('link');
                // if (Get.arguments["order"] == order.text) data.remove('order');
                createDio()
                    .patch(
                  '/videos/${Get.arguments.id}/',
                  data: data,
                )
                    .then((value) {
                  Provider.of<VideosState>(context, listen: false).setVideos();
                  Get.back();
                });
              } else {
                createDio()
                    .post(
                  '/videos/',
                  data: data,
                )
                    .then((value) {
                  Provider.of<VideosState>(context, listen: false).setVideos();
                  Get.back();
                });
              }
            }
          },
        ),
      ),
      appBar: AppHeader(
        text: Get.arguments != null ? 'Редактирование видео' : 'Создание видео',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
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
                'Введите ссылку на ролик',
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
                validator: (text) {
                  var uri = Uri.tryParse(link.text);
                  if (uri != null) {
                    if (link.text.contains('?v=')) {
                      return null;
                    } else {
                      return 'Неверный адрес';
                    }
                  } else {
                    return 'Неверный адрес';
                  }
                },
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
      ),
    );
  }
}
