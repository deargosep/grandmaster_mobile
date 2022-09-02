import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/menu/about/about.dart';
import 'package:grandmaster/screens/menu/learnings/learnings.dart';
import 'package:grandmaster/screens/menu/video/videos.dart';
import 'package:grandmaster/utils/dialog.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../screens/menu/places/places.dart';
import '../state/user.dart';
import 'events_card.dart';
import 'images/brand_icon.dart';
import 'news_card.dart';

class BrandCard extends StatelessWidget {
  const BrandCard(this.item, this.onHide, this.onDelete,
      {Key? key, this.type = 'news', this.withPadding = true})
      : super(key: key);
  final item;
  final type;
  final onDelete;
  final onHide;
  final bool withPadding;
  @override
  Widget build(BuildContext context) {
    Widget getCard() {
      switch (type) {
        case 'news':
          return NewsCard(item: item);
        case 'events':
          return EventCard(item: item);
        case 'places':
          return PlaceCard(item: item);
        case 'videos':
          return VideoCard(item);
        case 'about':
          return AboutCard(item: item);
        case 'learning':
          return LearningCard(item);
        default:
          return Text('Wrong type!');
      }
    }

    String getPrompts() {
      switch (type) {
        case 'news':
          return 'данную новость';
        case 'events':
          return 'данное мероприятие';
        case 'places':
          return 'данный зал';
        case 'videos':
          return "данное видео";
        case 'about':
          return "данный контент";
        default:
          return "данный объект";
      }
    }

    String getUrl() {
      switch (type) {
        case 'news':
          return '/add_edit_article';
        case 'events':
          return '/events/add';
        //  TODO
        case 'learning':
          return "/learnings/add";
        case 'places':
          return '/places/add';
        case 'videos':
          return "/videos/add";
        case 'about':
          return "/about/add";
        default:
          return "/bar";
      }
    }

    User user = Provider.of<UserState>(context).user;
    return Slidable(
      key: Key(item.id.toString()),
      enabled: user.role == 'moderator' || user.role == 'admin',
      endActionPane:
          ActionPane(extentRatio: 0.3, motion: ScrollMotion(), children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: type == 'learning' ? 0 : 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BrandIcon(
                  icon: 'settings',
                  color: Colors.black,
                  height: 18,
                  width: 18,
                  onTap: () {
                    Get.toNamed(getUrl(), arguments: item);
                  },
                ),
                BrandIcon(
                  icon: 'no_view',
                  color: Colors.black,
                  height: 18,
                  width: 18,
                  onTap: () {
                    showCustomDialog(
                        context, 'Скрыть ${getPrompts()}?', 'Скрыть', () {
                      onHide();
                    });
                  },
                ),
                BrandIcon(
                  icon: 'x',
                  color: Colors.black,
                  height: 18,
                  width: 18,
                  onTap: () {
                    showCustomDialog(
                        context, 'Удалить ${getPrompts()}?', 'Удалить', () {
                      onDelete();
                    });
                  },
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
            border: type == 'learning' || type == 'videos'
                ? null
                : Border(
                    bottom: BorderSide(color: Color(0xFFF3F3F3), width: 2))),
        child: Padding(
            padding: withPadding ? const EdgeInsets.all(20) : EdgeInsets.zero,
            child: getCard()),
      ),
    );
  }
}

class LoadingImage extends StatelessWidget {
  const LoadingImage(this.url, {Key? key, this.height, this.width})
      : super(key: key);
  final String url;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Image.network(url, fit: BoxFit.cover, height: height, width: width,
        loadingBuilder: (context, child, loading) {
      if (loading == null)
        return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)), child: child);
      return Container(
        height: height,
        width: width,
        child: Skeleton(
            isLoading: true,
            skeleton: SkeletonLine(
              style: SkeletonLineStyle(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  height: height ?? 132,
                  width: width ?? double.infinity),
            ),
            child: child),
      );
    });
  }
}
