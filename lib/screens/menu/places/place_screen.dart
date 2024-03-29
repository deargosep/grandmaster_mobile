import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:grandmaster/widgets/images/circle_logo.dart';

import '../schedule/schedule_table.dart';

class PlaceScreen extends StatefulWidget {
  PlaceScreen({Key? key}) : super(key: key);

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  final PlaceType item = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        noPadding: true,
        scrollable: true,
        body: Stack(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              // decoration: BoxDecoration(
              color: item.cover != null
                  ? null
                  : Theme.of(context).colorScheme.secondary,
              child: item.cover != null
                  ? LoadingImage(
                      item.cover!,
                      height: 220,
                      borderRadius: BorderRadius.zero,
                    )
                  : null,
            ),
            Container(
              margin: EdgeInsets.only(top: 200),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 32,
                          ),
                          Text(
                            item.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary),
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
                              Expanded(
                                child: Text(
                                  item.address,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          item.trainers.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Тренеры',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Column(
                                      children: item.trainers
                                          .map((e) => TrainerCard(e))
                                          .toList(),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 68,
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
        ));
  }
}

class TrainerCard extends StatefulWidget {
  const TrainerCard(this.item, {Key? key}) : super(key: key);
  final Trainer item;

  @override
  State<TrainerCard> createState() => _TrainerCardState();
}

class _TrainerCardState extends State<TrainerCard> {
  late List<TrainerSchedule>? schedules;

  @override
  void initState() {
    super.initState();
    if (widget.item.schedules != null) {
      List<TrainerSchedule> oldSchedules = widget.item.schedules!;
      List<TrainerSchedule> newSchedules = oldSchedules.map((e) {
        List<TScheduleTime> unsortedItems = e.items;
        unsortedItems.sort((a, b) => a.finishTime.compareTo(b.finishTime));
        return TrainerSchedule(
            minAge: e.minAge, maxAge: e.maxAge, items: unsortedItems);
      }).toList();
      newSchedules.sort((a, b) => b.minAge.compareTo(a.minAge));
      schedules = newSchedules;
    }
  }

  // ExpandableController controller = ExpandableController();
  // final Trainer item = Trainer(id: 2, fio: 'fio', category: category, daysOfWeek: daysOfWeek, time: time)
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Color(0xFF000000).withOpacity(0.06),
              blurRadius: 4,
              offset: Offset(0, 6))
        ],
      ),
      child: ExpandablePanel(
          // controller: controller,
          theme: ExpandableThemeData(
              iconSize: widget.item.schedules!.isNotEmpty ? null : 0,
              iconColor: widget.item.schedules!.isNotEmpty
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.white,
              iconPadding: EdgeInsets.only(top: 27, right: 14)),
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                    height: 46,
                    width: 46,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: CircleAvatar(
                          backgroundColor: Colors.black12,
                          child: widget.item.photo != null
                              ? Avatar(
                                  widget.item.photo!,
                                  height: 46,
                                  width: 46,
                                )
                              : CircleLogo(
                                  height: 46,
                                  width: 46,
                                ),
                        ))),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    widget.item.fio,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          collapsed: Container(),
          expanded: Column(
            children: [
              ...schedules!.map((e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Возрастная группа ${e.minAge}-${e.maxAge} лет',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...e.items
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Container(
                                            width: e.daysOfWeek.length < 3
                                                ? 40
                                                : 60,
                                            child: Text(
                                                '${e.daysOfWeek.map((e) => getDay(e))}'
                                                    .replaceAll('(', '')
                                                    .replaceAll(')', ''),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondaryContainer)),
                                          ),
                                          SizedBox(
                                            width: 11,
                                          ),
                                          Container(
                                            width: 29,
                                            height: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                              '${e.startTime} - ${e.finishTime}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondaryContainer))
                                        ],
                                      ),
                                    )
                                    .toList()
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      // index != 2 ? Divider() : Container()
                    ],
                  ))
            ],
          )),
    );
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Color(0xFF000000).withOpacity(0.06),
              blurRadius: 4,
              offset: Offset(0, 6))
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          CircleAvatar(),
          SizedBox(
            width: 16,
          ),
          Text(
            widget.item.fio,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500),
          ),
          Spacer(),
          BrandIcon(
            icon: 'arrow_down',
            height: 11,
            width: 11,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
    );
  }
}
