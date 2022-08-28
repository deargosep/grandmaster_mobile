import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/bottom_panel.dart';

class AddEditPlace extends StatefulWidget {
  AddEditPlace({Key? key}) : super(key: key);

  @override
  State<AddEditPlace> createState() => _AddEditPlaceState();
}

class _AddEditPlaceState extends State<AddEditPlace> {
  final ImagePicker _picker = ImagePicker();
  XFile? cover;
  PlaceType? item = Get.arguments;
  TextEditingController name =
      TextEditingController(text: Get.arguments?.name ?? '');
  TextEditingController description =
      TextEditingController(text: Get.arguments?.description ?? '');
  TextEditingController address =
      TextEditingController(text: Get.arguments?.address ?? '');
  TextEditingController order =
      TextEditingController(text: Get.arguments?.order.toString() ?? '');
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      appBar: AppHeader(
        text: '${item != null ? 'Редактирование' : 'Создание'} зала',
      ),
      bottomNavigationBar: BottomPanel(
        withShadow: false,
        child: BrandButton(
          text: 'Далее',
          onPressed: () async {
            if (_formKey.currentState != null) if (_formKey.currentState!
                .validate()) {
              Map<String, dynamic> data = {
                "title": name.text,
                "description": description.text,
                "address": address.text,
                "order": order.text,
                "hidden": false
              };
              FormData formData = FormData.fromMap(data);
              if (cover != null) {
                formData = await getFormFromFile(cover!, 'cover', data);
              }
              if (item != null) {
                Get.toNamed('/places/add/trainers', arguments: {
                  "formData": formData,
                  "editMode": true,
                  "id": item?.id
                });
                // createDio()
                //     .patch('/gyms/${item?.id}/',
                //         data: formData,
                //         options: Options(contentType: 'multipart/form-data'))
                //     .then((value) {
                //   Get.back();
                //   Provider.of<PlacesState>(context, listen: false).setPlaces();
                // });
              } else {
                Get.toNamed('/places/add/trainers', arguments: {
                  "formData": formData,
                  "editMode": false,
                  "id": item?.id
                });
                // createDio()
                //     .post('/gyms/${item?.id}/',
                //     data: formData,
                //     options: Options(contentType: 'multipart/form-data'))
                //     .then((value) {
                //   Get.back();
                //   Provider.of<PlacesState>(context, listen: false).setPlaces();
                // });
              }
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                'Введите адрес',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(
                height: 24,
              ),
              Input(
                label: 'Адрес',
                controller: address,
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
                    cover = image;
                  });
                },
                child: Container(
                  height: 132,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Color(0xFFFBF7F7),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: item?.cover != null
                      ? Image.network(item!.cover!)
                      : cover != null
                          ? !kIsWeb
                              ? Image.file(
                                  File(cover!.path),
                                  height: 132,
                                  width: double.maxFinite,
                                )
                              : Image.network(cover!.path,
                                  height: 132, width: double.maxFinite)
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
      ),
    );
  }
}
