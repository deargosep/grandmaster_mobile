import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoWatchScreen extends StatefulWidget {
  const VideoWatchScreen({Key? key}) : super(key: key);

  @override
  State<VideoWatchScreen> createState() => _VideoWatchScreenState();
}

class _VideoWatchScreenState extends State<VideoWatchScreen> {
  late YoutubePlayerController controller;
  var arguments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = YoutubePlayerController.fromVideoId(
        videoId: Uri.parse(arguments).queryParameters["v"]!);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
        builder: (context, child) {
          return child;
        },
        controller: controller);
  }
}
