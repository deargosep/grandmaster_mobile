import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/brand_pill.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key? key, required this.item}) : super(key: key);
  final EventType item;
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondaryContainer;

    return GestureDetector(
      onTap: () {
        Get.toNamed('/event', arguments: item);
      },
      child: Container(
        height: 286,
        width: 335,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image cover
            Container(
              height: 132,
              width: double.infinity,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: LoadingImage(item.cover)),
            ),
            // meta info
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              ),
            ),
            // description
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
              child: Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w500, color: color),
              ),
            ),
            SizedBox(
              height: 16,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 12,
                      width: 12,
                      child: BrandIcon(
                        icon: 'calendar',
                        height: 12,
                        width: 12,
                        color: color,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${DateFormat('d.MM.y').format(item.timeDateStart)} в ${DateFormat('Hm').format(item.timeDateStart)} - ${DateFormat('d.MM.y').format(item.timeDateEnd)}",
                      style: TextStyle(fontSize: 12, color: color),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 17.33,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: BrandPill(!item.open),
            )
          ],
        ),
      ),
    );
  }
}
