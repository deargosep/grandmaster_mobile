import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/brand_pill.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    EventType item = Get.arguments;
    item = Provider.of<EventsState>(context)
        .events
        .firstWhere((element) => element.id == item.id);
    String getRole() {
      return Provider.of<UserState>(context, listen: false).user.role;
    }

    bool hasChildren() {
      return Provider.of<UserState>(context, listen: false)
          .user
          .children
          .isNotEmpty;
    }

    bool hasMoreThanOneChild() {
      return Provider.of<UserState>(context, listen: false)
              .user
              .children
              .length >
          0;
    }

    bool zapisan = item.members.firstWhereOrNull(
            (element) => Provider.of<UserState>(context).user.id) !=
        null;

    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      bottomNavigationBar: BottomPanel(
          withShadow: false,
          height: zapisan ? 148.0 : 85.0,
          child: getRole() == 'moderator' ||
                  (getRole() == 'sportsmen' && !item.open)
              ? Container()
              : Column(
                  children: [
                    zapisan
                        ? BrandButton(
                            type: 'info',
                            text: 'Вы уже записаны на мероприятие',
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer),
                            icon: 'check',
                            iconColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer)
                        : Container(),
                    zapisan
                        ? SizedBox(
                            height: 16,
                          )
                        : Container(),
                    BrandButton(
                      onPressed: () {
                        // if not trainer or parent (multiple students)
                        if (getRole() != 'trainer' && !hasChildren()) {
                          if (zapisan) {
                            if (!item.open) {
                              // посмотреть список
                              Get.toNamed('/events/list', arguments: {
                                "item": item,
                                "options": {"type": "view"}
                              });
                            }
                            if (item.open) {
                              // отменить запись
                              createDio().put(
                                '/events/members/',
                                data: {"members": []},
                                queryParameters: {"event": item.id},
                              );
                            }
                          }

                          if (!zapisan) {
                            // записаться
                            // if (mounted)
                            //   setState(() {
                            //     zapisan = true;
                            //   });
                            createDio().put('/events/members/',
                                queryParameters: {
                                  "event": item.id
                                }).then((value) {
                              Get.toNamed('/success',
                                  arguments:
                                      'Вы успешно записались на мероприятие');
                            });
                            // Get.toNamed('/success',
                            //     arguments:
                            //         'Вы успешно записались на мероприятие');
                          }
                        } else {
                          if (getRole() == "trainer") {
                            if (!zapisan) {
                              // if (mounted)
                              //   setState(() {
                              //     zapisan = true;
                              //   });
                              // add
                              Get.toNamed('/events/list', arguments: {
                                "item": item,
                                "options": {"type": "add"}
                              });
                            }
                            if (zapisan) {
                              // edit
                              Get.toNamed('/events/list', arguments: {
                                "item": item,
                                "options": {"type": "edit"}
                              });
                            }
                          }

                          if (hasChildren()) {
                            if (!hasMoreThanOneChild()) {
                              if (mounted)
                                setState(() {
                                  zapisan = true;
                                });
                              Get.toNamed('/success',
                                  arguments:
                                      'Вы успешно записались на мероприятие');
                            }
                            if (hasMoreThanOneChild()) {
                              if (!item.open) {
                                Get.toNamed('/events/list', arguments: {
                                  "item": item,
                                  "options": {"type": "view"}
                                });
                              }
                              if (item.open) {
                                if (mounted)
                                  setState(() {
                                    zapisan = true;
                                  });
                                Get.toNamed('/events/list', arguments: {
                                  "item": item,
                                  "options": {"type": "choose"}
                                });
                              }
                            }
                          }
                        }
                      },
                      text: !hasChildren() && getRole() != 'trainer'
                          ? zapisan
                              ? !item.open
                                  ? 'Посмотреть список'
                                  : 'Отменить запись'
                              : 'Записаться'
                          : zapisan
                              ? getRole() != 'trainer'
                                  ? 'Редактировать список'
                                  : 'Посмотреть список'
                              : hasMoreThanOneChild()
                                  ? 'Записать спортсменов'
                                  : 'Записаться',
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    )
                  ],
                )),
      body: Stack(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            child: Image.network(
              item.cover,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 32),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            BrandPill(!item.open),
                            Spacer(),
                            getRole() == 'moderator'
                                ? BrandIcon(
                                    icon: 'download',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          item.name ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        // Description
                        Text(
                          item.description,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          'Дата и время проведения',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              child: BrandIcon(
                                icon: 'calendar',
                                height: 15,
                                width: 15,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${DateFormat('d.MM.y').format(item.timeDateStart)} в ${DateFormat('Hm').format(item.timeDateStart)} - ${DateFormat('d.MM.y').format(item.timeDateEnd)}",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          'Адрес',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              child: BrandIcon(
                                icon: 'geo',
                                height: 15,
                                width: 15,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              item.address,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          children: [
                            Text(
                              'Запись будет закрыта',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                            ),
                            Text(
                              " ${DateFormat('d.MM.y').format(item.timeDateEnd)} в ${DateFormat('Hm').format(item.timeDateEnd)}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                20, 38 + MediaQuery.of(context).viewInsets.top, 0, 0),
            child: BrandIcon(
              icon: 'back_arrow',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
