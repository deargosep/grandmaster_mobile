import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({Key? key, required this.item}) : super(key: key);
  final ArticleType item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/article', arguments: item);
      },
      child: Container(
        height: 244,
        width: double.infinity,
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
              decoration: BoxDecoration(
                  color: item.cover != null
                      ? null
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: item.cover != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: LoadingImage(item.cover))
                  : Center(
                      child: Text('Нет картинки'),
                    ),
            ),
            // meta info
            Container(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.name,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
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
            Expanded(
              flex: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
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
                      DateFormat('d MMMM y').format(item.dateTime),
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
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 12,
                        width: 12,
                        child: BrandIcon(
                          icon: 'view',
                          height: 8,
                          width: 12,
                        ),
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
