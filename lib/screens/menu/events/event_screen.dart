import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/brand_pill.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final EventType item = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
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
                        BrandPill(item.timeDateEnd),
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
                              " ${DateFormat('d.MM.y').format(item.registerEnd)} в ${DateFormat('Hm').format(item.registerEnd)}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            BrandButton(
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
                                    .secondaryContainer),
                            SizedBox(
                              height: 16,
                            ),
                            BrandButton(
                              text: 'Вы уже записаны на мероприятие',
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            )
                          ],
                        )
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
