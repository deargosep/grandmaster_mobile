import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
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
  File? cover;
  PlaceType? item = Get.arguments;
  TextEditingController name =
      TextEditingController(text: Get.arguments?.name ?? '');
  TextEditingController description =
      TextEditingController(text: Get.arguments?.description ?? '');
  TextEditingController address =
      TextEditingController(text: Get.arguments?.address ?? '');
  TextEditingController order =
      TextEditingController(text: Get.arguments?.order.toString() ?? '');

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
            Map data = {
              // "name": name.text,
              // "description": description.text,
              // "number": order.text,
              "hidden": false
            };
            // if (cover != null) {
            //   final Uint8List? compressedCover = await testCompressFile(cover!);
            //   if (compressedCover != null) {
            //     data["cover"] = base64Encode(compressedCover);
            //   }
            // }
            if (item != null) {
              if (name.text != item!.name) {
                data.addAll({"name": name.text});
              }
              if (description.text != item!.description) {
                data.addAll({"description": description.text});
              }
              if (address.text != item!.address) {
                data.addAll({"address": address.text});
              }
              if (order.text.toString() != item!.order.toString()) {
                data.addAll({"number": order.text});
              }
              data.addAll({"editMode": true});
              // createDio()
              //     .patch('/gyms/${item!.id}/', data: data)
              //     .then((value) {
              //   Provider.of<PlacesState>(context, listen: false).setPlaces();
              //   Get.back();
              // });
            } else {
              data.addAll({
                "name": name.text,
                "description": description.text,
                "address": address.text,
                "number": order.text,
                "editMode": false
              });
              // createDio().post('/gyms/', data: data).then((value) {
              //   Provider.of<PlacesState>(context, listen: false).setPlaces();
              //   Get.back();
              // });
            }
            Get.toNamed('/places/add/trainers', arguments: data);
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
                  cover = File(image!.path);
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
