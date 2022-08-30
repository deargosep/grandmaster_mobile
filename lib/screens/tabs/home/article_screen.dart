import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ArticleScreen extends StatefulWidget {
  ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final ArticleType item = Get.arguments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      createDio().get('/news/${item.id}/').then((value) {
        Provider.of<Articles>(context, listen: false).setNews();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      bottomNavigationBar: BottomBarWrap(currentTab: 1),
      body: Stack(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
                color:
                    item.cover != null ? null : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: item.cover != null
                ? Image.network(
                    item.cover,
                    fit: BoxFit.cover,
                  )
                : Container(color: Theme.of(context).colorScheme.secondary),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.name ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              DateFormat('dd MMMM y, HH:mm')
                                  .format(item.dateTime),
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          // Description
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.description,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          item.photos.isNotEmpty
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Фотографии',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 110,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: item.photos.length,
                          itemBuilder: (context, index) {
                            final photo = item.photos[index];
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed('/article/photos', arguments: {
                                  "images": item.photos,
                                  "id": photo["id"]
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                      right: 16, left: index == 0 ? 16 : 0),
                                  height: 110,
                                  width: 150,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    child: Image.network(
                                      photo["image"],
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            );
                          },
                        ),
                      ),
                    )
                  ],
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
