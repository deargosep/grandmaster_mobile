import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/about.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../../utils/custom_scaffold.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AboutState>(context, listen: false).setAbout();
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    var user = Provider.of<UserState>(context);
    bool isLoaded = Provider.of<AboutState>(context).isLoaded;
    List list = Provider.of<AboutState>(context).about;
    return CustomScaffold(
      noPadding: true,
      bottomNavigationBar: BottomBarWrap(currentTab: 0),
      appBar: AppHeader(
        text: 'О клубе',
        icon: user.user.role == 'moderator' ? 'plus' : '',
        iconOnTap: () {
          Get.toNamed('/about/add');
        },
      ),
      body: isLoaded
          ? list.isNotEmpty
              ? RefreshIndicator(
                  onRefresh:
                      Provider.of<AboutState>(context, listen: false).setAbout,
                  child: Content(),
                )
              : Text('Нет контента')
          : Center(
              child: CircularProgressIndicator(),
            ),
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
      Provider.of<AboutState>(context, listen: false).setAbout();
    });
  }

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<AboutState>(context, listen: true).about;
    var user = Provider.of<UserState>(context);
    return ListView(
        children: list.map((item) {
      return BrandCard(
        item,
        // TODO
        () {
          createDio().patch('/club_content/${item.id}/', data: {
            "hidden": true
          }).then((value) =>
              Provider.of<AboutState>(context, listen: false).setAbout());
        },
        () {
          createDio().delete('/club_content/${item.id}/').then((value) =>
              Provider.of<AboutState>(context, listen: false).setAbout());
        },
        type: 'about',
      );
    }).toList());
    // return ListView.builder(
    //     itemCount: list.length,
    //     itemBuilder: (context, index) {
    //       return Padding(
    //         padding: const EdgeInsets.all(20),
    //         child: AboutCard(item: list[index]),
    //       );
    //     });
  }
}

class AboutCard extends StatelessWidget {
  const AboutCard({Key? key, required this.item}) : super(key: key);
  final AboutType item;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      width: 335,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image cover
          Container(
            height: 200,
            width: double.infinity,
            child: item.cover != null
                ? LoadingImage(
                    item.cover,
                    height: 200,
                  )
                : Container(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
          ), // TODO: should be an Image (backend)
          // meta info
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
            child: Column(
              children: [
                Text(
                  item.name,
                  maxLines: 3,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
          // description
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
          //   child: Text(
          //     item.description,
          //     maxLines: 3,
          //     overflow: TextOverflow.fade,
          //     softWrap: false,
          //     style: TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.w500,
          //         color: Color(0xFFAC9595)),
          //   ),
          // ),
        ],
      ),
    );
  }
}
