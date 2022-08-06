import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../state/user.dart';
import 'events_card.dart';
import 'images/brand_icon.dart';
import 'news_card.dart';

class BrandCard extends StatelessWidget {
  const BrandCard(this.item, {Key? key, this.type = 'news'}) : super(key: key);
  final item;
  final type;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    return Slidable(
      enabled: user.role == 'moderator' || user.role == 'admin',
      endActionPane:
          ActionPane(extentRatio: 0.3, motion: ScrollMotion(), children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BrandIcon(
                  icon: 'settings',
                  color: Colors.black,
                  height: 18,
                  width: 18,
                  onTap: () {
                    Get.toNamed(
                        type == 'news'
                            ? '/add_edit_article'
                            : '/add_edit_event',
                        arguments: item.id);
                  },
                ),
                BrandIcon(
                  icon: 'no_view',
                  color: Colors.black,
                  height: 18,
                  width: 18,
                ),
                BrandIcon(
                  icon: 'x',
                  color: Colors.black,
                  height: 18,
                  width: 18,
                ),
                SizedBox(
                  width: 0,
                )
              ],
            ),
          ),
        ),
      ]),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0xFFF3F3F3), width: 2))),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: type == 'news' ? NewsCard(item: item) : EventCard(item: item),
        ),
      ),
    );
  }
}
