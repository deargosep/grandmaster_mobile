import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoWatchScreen extends StatefulWidget {
  const VideoWatchScreen({Key? key}) : super(key: key);

  @override
  State<VideoWatchScreen> createState() => _VideoWatchScreenState();
}

class _VideoWatchScreenState extends State<VideoWatchScreen> {
  late YoutubePlayerController controller;
  var arguments = Get.arguments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = YoutubePlayerController.fromVideoId(
        videoId: Uri.parse(arguments).queryParameters["v"]!, autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => CustomScaffold(
        noPadding: true,
        backgroundColor: Colors.black,
        appBar: orientation == Orientation.portrait
            ? AppHeader(
                textColor: Colors.white,
                text: 'Видео',
                withBack: true,
              )
            : null,
        body: YoutubePlayer(controller: controller),
      ),
    );
  }
}
