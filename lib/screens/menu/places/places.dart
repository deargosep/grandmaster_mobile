import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../state/places.dart';
import '../../../state/user.dart';
import '../../../utils/tablet.dart';
import '../../../widgets/images/brand_icon.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PlacesState>(context, listen: false).setPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    bool isModer() {
      return user.role == 'moderator';
    }

    List<PlaceType> items = Provider.of<PlacesState>(context).places;
    bool isLoaded = Provider.of<PlacesState>(context).isLoaded;

    return CustomScaffold(
        noPadding: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Залы',
          icon: isModer() ? 'plus' : '',
          iconOnTap: isModer()
              ? () {
                  Get.toNamed('/places/add');
                }
              : null,
        ),
        body: isLoaded
            ? items.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: Provider.of<PlacesState>(context, listen: false)
                        .setPlaces,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: getDeviceType() == 'tablet' ? 2 : 1,
                            crossAxisSpacing: 0.0,
                            mainAxisSpacing: 0.0,
                            childAspectRatio:
                                getDeviceType() == 'tablet' ? 0.89 : 1.1),
                        itemCount: items.length,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Get.toNamed('/places', arguments: items[index]);
                              },
                              child: BrandCard(
                                items[index],
                                // TODO
                                () {
                                  createDio().patch('/gyms/${items[index].id}/',
                                      data: {"hidden": true});
                                  Provider.of<PlacesState>(context).setPlaces();
                                },
                                () {
                                  createDio()
                                      .delete('/gyms/${items[index].id}/');
                                  Provider.of<PlacesState>(context).setPlaces();
                                },

                                type: 'places',
                              ),
                            )),
                  )
                : Text('Нет залов')
            : Center(
                child: CircularProgressIndicator(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image cover
            Container(
              height: 132,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: item.cover != null
                    ? LoadingImage(item.cover!)
                    : Container(color: Theme.of(context).colorScheme.secondary),
              ),
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

            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                Expanded(
                  child: Text(
                    item.address,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    // "${DateFormat('d.MM.y').format(item.timeDateStart)} в ${DateFormat('Hm').format(item.timeDateStart)} - ${DateFormat('d.MM.y').format(item.timeDateEnd)}",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: color),
                  ),
                ),
              ],
            ),
            // description
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
              child: Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w500, color: color),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            item.trainers.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 70,
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    child: item.trainers[0].photo != null
                                        ? Avatar(
                                            item.trainers[0].photo!,
                                            height: 30,
                                            width: 30,
                                          )
                                        : Container()),
                                ...item.trainers.map((e) {
                                  var index = item.trainers.indexOf(e);
                                  if (index == 0) return Container();
                                  return Positioned(
                                      left: index == 1
                                          ? 20
                                          : index == 2
                                              ? 40
                                              : 60,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          child: e.photo != null
                                              ? Avatar(
                                                  e.photo!,
                                                  height: 30,
                                                  width: 30,
                                                )
                                              : Container()));
                                }).toList()
                                // Positioned(
                                //   left: 40,
                                //   child: CircleAvatar(
                                //       radius: 15,
                                //       backgroundColor: Theme.of(context).primaryColor,
                                //       child: Image.network(item.trainers[0].photo)),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
