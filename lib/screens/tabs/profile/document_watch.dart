import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DocumentWatchScreen extends StatelessWidget {
  const DocumentWatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String image = Get.arguments;
    return Stack(
      children: [
        PhotoViewGallery.builder(
            itemCount: 1,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(image),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                // heroAttributes:
                //     PhotoViewHeroAttributes(tag: images[index]["id"]),
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
