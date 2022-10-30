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

class LoadingImage extends StatefulWidget {
  const LoadingImage(this.url,
      {Key? key, this.height, this.width, this.borderRadius, this.onLoad})
      : super(key: key);
  final String url;
  final double? width;
  final double? height;
  final VoidCallback? onLoad;
  final BorderRadius? borderRadius;

  @override
  State<LoadingImage> createState() => _LoadingImageState();
}

class _LoadingImageState extends State<LoadingImage> {
  late Image _image;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _image = Image.network(
      widget.url,
      fit: BoxFit.cover,
      height: widget.height,
      width: widget.width ?? double.infinity,
    );
    _image.image
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((image, synchronousCall) {
      if (widget.onLoad != null) {
        widget.onLoad!();
      }
      if (mounted)
        setState(() {
          _loading = false;
        });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Skeleton(
        isLoading: _loading,
        skeleton: SkeletonLine(
          style: SkeletonLineStyle(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              height: widget.height ?? 132,
              width: widget.width ?? double.infinity),
        ),
        child: ClipRRect(
            borderRadius:
                widget.borderRadius ?? BorderRadius.all(Radius.circular(15)),
            child: _image));
  }
}
