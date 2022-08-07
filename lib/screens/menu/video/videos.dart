import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:provider/provider.dart';

import '../../../state/user.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    bool isModer() {
      return user.role == 'moderator';
    }

    return CustomScaffold(
        noPadding: true,
        scrollable: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Видео',
          icon: isModer() ? 'plus' : null,
          iconOnTap: isModer()
              ? () {
                  Get.toNamed('/learnings/add');
                }
              : null,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            ...List.generate(3, (index) => VideoCard())
          ],
        ));
  }
}

class VideoCard extends StatelessWidget {
  const VideoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 219,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 132,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 35),
              decoration: BoxDecoration(
                  color: Color(0xFFE7E7E7),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: BrandIcon(
                height: 61,
                width: 61,
                icon: 'play',
                color: Color(0xFFA8A8A8),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Название видео',
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
    );
  }
}
