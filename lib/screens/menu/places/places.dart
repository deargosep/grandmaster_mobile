import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../state/places.dart';
import '../../../state/user.dart';
import '../../../widgets/images/brand_icon.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    bool isModer() {
      return user.role == 'moderator';
    }

    List<PlaceType> items = Provider.of<Places>(context).places;

    return CustomScaffold(
        noPadding: true,
        scrollable: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Залы',
          icon: isModer() ? 'plus' : null,
          iconOnTap: isModer()
              ? () {
                  Get.toNamed('/places/add');
                }
              : null,
        ),
        body: Column(
          children: [
            ...items.map((e) => GestureDetector(
                  onTap: () {
                    Get.toNamed('/places', arguments: e);
                  },
                  child: BrandCard(
                    e,
                    type: 'places',
                  ),
                ))
          ],
        ));
  }
}

class PlaceCard extends StatelessWidget {
  const PlaceCard({Key? key, required this.item}) : super(key: key);
  final PlaceType item;
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondaryContainer;

    return GestureDetector(
      onTap: () {
        Get.toNamed('/place', arguments: item);
      },
      child: Container(
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
                  color: Theme.of(context).colorScheme.secondary,
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

            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 13.33,
                      width: 13.33,
                      child: BrandIcon(
                        icon: 'geo',
                        height: 13.33,
                        width: 13.33,
                        color: color,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      item.address,
                      // "${DateFormat('d.MM.y').format(item.timeDateStart)} в ${DateFormat('Hm').format(item.timeDateStart)} - ${DateFormat('d.MM.y').format(item.timeDateEnd)}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: color),
                    )
                  ],
                ),
              ],
            ),
            // description
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
              child: Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w500, color: color),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 70,
                      child: Stack(
                        children: [
                          CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary),
                          Positioned(
                            left: 20,
                            child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer),
                          ),
                          Positioned(
                            left: 40,
                            child: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
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
