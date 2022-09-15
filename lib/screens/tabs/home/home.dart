import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/news_card.dart';
import 'package:provider/provider.dart';

import '../../../utils/custom_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  Future<Response> getNews() async {
    var response = await createDio().get('/news/');
    return response;
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    var user = Provider.of<UserState>(context);
    return CustomScaffold(
      noPadding: true,
      // scrollable: true,
      appBar: AppHeader(
        text: 'Новости',
        withBack: false,
        icon: user.user.role == 'moderator' ? 'plus' : '',
        iconOnTap: () {
          Get.toNamed('/add_edit_article');
        },
      ),
      body: Content(),
    );
  }
}

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Articles>(context, listen: false).setNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Articles>(context, listen: true).news;

    Orientation currentOrientation = MediaQuery.of(context).orientation;

    bool isLoaded = Provider.of<Articles>(context).isLoaded;
    return isLoaded
        ? list.isNotEmpty
            ? RefreshIndicator(
                onRefresh:
                    Provider.of<Articles>(context, listen: false).setNews,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    var item = list[index];
                    return BrandCard(
                      item,
                      // TODO
                      () {
                        createDio()
                            .patch('/news/${item.id}/',
                                data: FormData.fromMap({"hidden": true}))
                            .then((value) =>
                                Provider.of<Articles>(context, listen: false)
                                    .setNews());
                      },
                      () {
                        createDio().delete('/news/${item.id}/').then((value) =>
                            Provider.of<Articles>(context, listen: false)
                                .setNews());
                      },
                    );
                  },
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: getDeviceType() == 'tablet' ? 2 : 1,
                  //     crossAxisSpacing: 0.0,
                  //     mainAxisSpacing: 0.0,
                  //     childAspectRatio: getDeviceType() == 'tablet'
                  //         ? currentOrientation == Orientation.portrait
                  //             ? 1
                  //             : 1.5
                  //         : 1.25),
                ),
              )
            : Center(
                child: Text('Нет новостей'),
              )
        : Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: NewsCard(item: list[index]),
          );
        });
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white);
    const textStyleBold = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white);
    return Container(
      height: 76 + MediaQuery.of(context).viewPadding.top,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
          16, 16 + MediaQuery.of(context).viewPadding.top, 16, 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          color: Theme.of(context).primaryColor),
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/change_city');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'События в городе',
              style: textStyle,
            ),
            Text(
              Provider.of<UserState>(context, listen: true).user.city,
              style: textStyleBold,
            )
          ],
        ),
      ),
    );
  }
}
