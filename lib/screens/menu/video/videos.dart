import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:grandmaster/state/videos.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../state/user.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  // bool _isInit = true;
  // bool _isLoading = false;
  //
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Products>(context).fetchAndSetProducts().then((_) => {
  //       setState(() {
  //         _isLoading = false;
  //       })
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // var request = await createDio().get('/videos/');
      // List<Video> newList = [
      //   ...request.data.map((e) {
      //     DateTime newDate = DateTime.parse(e["created_at"]);
      //     return Video(
      //         id: e["id"],
      //         name: e["title"],
      //         createdAt: newDate,
      //         link: e["link"]);
      //   }).toList()
      // ];
      // print(newList);
      Provider.of<VideosState>(context, listen: false).setVideos();
      // Provider.of<VideosState>(context, listen: false).setVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    bool isModer() {
      return user.role == 'moderator';
    }

    List videos = context.watch<VideosState>().videos;
    bool isLoaded = Provider.of<VideosState>(context, listen: true).isLoaded;
    return CustomScaffold(
        noPadding: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Видео',
          icon: isModer() ? 'plus' : '',
          iconOnTap: isModer()
              ? () {
                  Get.toNamed('/videos/add');
                }
              : null,
        ),
        body: isLoaded
            ? videos.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: RefreshIndicator(
                        onRefresh:
                            Provider.of<VideosState>(context, listen: false)
                                .setVideos,
                        child: ListView.builder(
                            // shrinkWrap: true,
                            // itemCount: videos.length,
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              return BrandCard(videos[index],
                                  type: 'videos',
                                  withPadding: false,
                                  key: Key(videos[index].id.toString()), () {
                                createDio().patch(
                                    '/videos/${videos[index].id}/',
                                    data: {"hidden": true});
                              }, () {
                                createDio()
                                    .delete('/videos/${videos[index].id}/')
                                    .then((value) {
                                  Provider.of<VideosState>(context,
                                          listen: false)
                                      .setVideos();
                                });
                              });
                            }),
                      ),
                    ))
                : Text('Нет видео')
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class VideoCard extends StatelessWidget {
  const VideoCard(this.item, {Key? key}) : super(key: key);
  final Video item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.link.contains('youtube')) {
          Get.toNamed('/videos/watch', arguments: item.link);
        } else {
          final url = Uri.parse(item.link);
          launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        height: 219,
        child: Column(
          children: [
            Container(
                height: 132,
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: LoadingImage(
                  'https://app.grandmaster.center/api/videos/image/?id=${Uri.parse(item.link).queryParameters["v"]}',
                )),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
