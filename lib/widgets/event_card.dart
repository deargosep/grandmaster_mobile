import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key? key, required this.item}) : super(key: key);
  final ArticleType item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/article', arguments: item);
      },
      child: Container(
        height: 244,
        width: 335,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Image cover
            Container(
              height: 132,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ), // TODO: should be an Image (backend)
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
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFAC9595)),
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
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      item.date,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary),
                    )
                  ],
                ),
                SizedBox(
                  width: 33,
                ),
                Row(
                  children: [
                    Container(
                      height: 12,
                      width: 12,
                      child: BrandIcon(
                        icon: 'view',
                        height: 12,
                        width: 12,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      item.views.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
