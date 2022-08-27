import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ArticlePhotosScreen extends StatelessWidget {
  const ArticlePhotosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map> images = [...Get.arguments["images"].map((e) => e).toList()];
    var initialId = Get.arguments["id"];
    return Stack(
      children: [
        PhotoViewGallery.builder(
            itemCount: images.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index]["image"]),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: images[index]["id"]),
              );
            }),
        Positioned(
            top: 60,
            left: 20,
            height: 30,
            width: 30,
            child: BrandIcon(
              icon: 'back_arrow',
              color: Colors.white,
            ))
      ],
    );
  }
}
