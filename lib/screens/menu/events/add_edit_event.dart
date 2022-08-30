import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/input.dart';
import 'package:grandmaster/widgets/select_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../state/events.dart';
import '../../../utils/dio.dart';

class AddEditEventScreen extends StatefulWidget {
  AddEditEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  final ImagePicker _picker = ImagePicker();

  TextEditingController name =
      TextEditingController(text: Get.arguments?.name ?? '');
  TextEditingController description =
      TextEditingController(text: Get.arguments?.description ?? '');
  TextEditingController address = TextEditingController(
      text: Get.arguments?.address == 'Нет адреса'
          ? ''
          : Get.arguments?.address ?? '');
  TextEditingController dateStart = TextEditingController(
      text: Get.arguments != null
          ? DateFormat('dd.MM.y').format(Get.arguments?.timeDateStart)
          : '');
  TextEditingController timeStart = TextEditingController(
      text: Get.arguments != null
          ? DateFormat('HH:mm').format(Get.arguments?.timeDateStart)
          : '');
  TextEditingController dateEnd = TextEditingController(
      text: Get.arguments != null
          ? DateFormat('dd.MM.y').format(Get.arguments?.timeDateEnd)
          : '');
  TextEditingController timeEnd = TextEditingController(
      text: Get.arguments != null
          ? DateFormat('HH:mm').format(Get.arguments?.timeDateEnd)
          : '');
  TextEditingController dateDeadline = TextEditingController(
      text: Get.arguments != null
          ? DateFormat('dd.MM.y').format(Get.arguments?.timeDateDeadline)
          : '');
  TextEditingController timeDeadline = TextEditingController(
      text: Get.arguments != null
          ? DateFormat('HH:mm').format(Get.arguments?.timeDateDeadline)
          : '');
  TextEditingController order =
      TextEditingController(text: Get.arguments?.order.toString());

  EventType? item = Get.arguments;
  // List<File?> images = [];
  File? cover;
  XFile? xCover;
  String select = Get.arguments != null
      ? Get.arguments.open
          ? 'Открытое'
          : 'Закрытое'
      : 'Открытое';
  final list = ['Открытое', 'Закрытое'];
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void onChangeSelect(value) {
      setState(() {
        select = value;
      });
    }

    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      appBar: AppHeader(
        text: item != null ? 'Редактирование записи' : 'Создание мероприятия',
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
                'Укажите адрес проведения',
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
                'Дата и время начала мероприятия',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(
                height: 24,
              ),
              InputDate(
                label: 'Дата',
                controller: dateStart,
              ),
              SizedBox(
                height: 16,
              ),
              Input(
                label: 'Время',
                controller: timeStart,
                maxLength: 5,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: timeStart.text != ''
                          ? TimeOfDay(
                              hour: int.parse(timeStart.text.split(':')[0]),
                              minute: int.parse(timeStart.text.split(':')[1]))
                          : TimeOfDay(hour: 0, minute: 0));
                  if (time != null) {
                    timeStart.text =
                        '${time.hour}:${time.minute}${time.minute < 10 ? '0' : ''}';
                  }
                },
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                'Дата и время окончания мероприятия',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(
                height: 24,
              ),
              InputDate(
                label: 'Дата',
                controller: dateEnd,
              ),
              SizedBox(
                height: 16,
              ),
              Input(
                label: 'Время',
                controller: timeEnd,
                maxLength: 5,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: timeEnd.text != ''
                          ? TimeOfDay(
                              hour: int.parse(timeEnd.text.split(':')[0]),
                              minute: int.parse(timeEnd.text.split(':')[1]))
                          : TimeOfDay(hour: 0, minute: 0));
                  if (time != null) {
                    timeEnd.text =
                        '${time.hour}:${time.minute}${time.minute < 10 ? '0' : ''}';
                  }
                },
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                'Дата и время окончания записи мероприятия',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(
                height: 24,
              ),
              InputDate(
                label: 'Дата',
                controller: dateDeadline,
              ),
              SizedBox(
                height: 16,
              ),
              Input(
                label: 'Время',
                controller: timeDeadline,
                maxLength: 5,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: timeDeadline.text != ''
                          ? TimeOfDay(
                              hour: int.parse(timeDeadline.text.split(':')[0]),
                              minute:
                                  int.parse(timeDeadline.text.split(':')[1]))
                          : TimeOfDay(hour: 0, minute: 0));
                  if (time != null) {
                    timeDeadline.text =
                        '${time.hour}:${time.minute}${time.minute < 10 ? '0' : ''}';
                  }
                },
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
                  final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery, imageQuality: 60);
                  setState(() {
                    xCover = image;
                    cover = File(image!.path);
                  });
                },
                child: Container(
                  height: 132,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Color(0xFFFBF7F7),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: cover != null || xCover != null
                      ? !kIsWeb
                          ? Image.file(
                              cover!,
                              height: 132,
                              width: double.maxFinite,
                            )
                          : Image.network(xCover!.path)
                      : item != null
                          ? item?.cover != null
                              ? Image.network(item!.cover!)
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 133, vertical: 28),
                                  child: BrandIcon(
                                    icon: 'upload',
                                    color: Color(0xFFE1D6D6),
                                  ),
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
                'Укажите тип мероприятия',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(
                height: 24,
              ),
              SelectList(onChange: onChangeSelect, value: select, items: list),
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
                height: 98,
              ),
              BrandButton(
                text: item != null ? 'Сохранить' : 'Опубликовать',
                onPressed: () async {
                  if (_formKey.currentState != null) if (_formKey.currentState!
                      .validate()) {
                    Map<String, dynamic> data = {
                      "name": name.text,
                      "description": description.text,
                      "start_date": DateFormat('dd.MM.y - HH:mm')
                          .parse('${dateStart.text} - ${timeStart.text}')
                          .toString(),
                      "end_date": DateFormat('dd.MM.y - HH:mm')
                          .parse('${dateEnd.text} - ${timeEnd.text}')
                          .toString(),
                      "deadline_date": DateFormat('dd.MM.y - HH:mm')
                          .parse('${dateDeadline.text} - ${timeDeadline.text}')
                          .toString(),
                      "address": address.text,
                      "open": select == 'Открытое' ? 'true' : 'false',
                      "order": order.text,
                      "hidden": false
                    };
                    FormData formData = FormData.fromMap(data);
                    if (cover != null) {
                      formData = !kIsWeb
                          ? await getFormFromFile(cover!, 'cover', data)
                          : await getFormFromXFile(xCover!, 'cover', data);
                    }
                    if (item != null) {
                      createDio()
                          .patch('/events/${item?.id}/',
                              data: formData,
                              options:
                                  Options(contentType: 'multipart/form-data'))
                          .then((value) {
                        Provider.of<EventsState>(context, listen: false)
                            .setEvents();
                        Get.back();
                      });
                    } else {
                      createDio()
                          .post(
                        '/events/',
                        data: formData,
                      )
                          .then((value) {
                        Get.back();
                        Provider.of<EventsState>(context, listen: false)
                            .setEvents();
                      });
                    }
                  }
                },
              ),
              SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ),
    );
  }
}
