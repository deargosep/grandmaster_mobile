import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/learnings.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/is_image.dart';

class LearningPhotoScreen extends StatefulWidget {
  const LearningPhotoScreen({Key? key}) : super(key: key);

  @override
  State<LearningPhotoScreen> createState() => _LearningPhotoScreenState();
}

class _LearningPhotoScreenState extends State<LearningPhotoScreen> {
  bool _loading = true;
  late NetworkImage _image;
  LearningType learning = Get.arguments;
  // PhotoViewController controller = PhotoViewController();
  // late ImageStream stream;
  @override
  void initState() {
    super.initState();
    _image = NetworkImage(learning.link);
    _image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((image, synchronousCall) {
      if (mounted)
        setState(() {
          _loading = false;
        });
    }));
    if (!isImage(learning.link)) {
      _loading = false;
    }
    // stream.addListener(ImageStreamListener((image, synchronousCall) {
    //
    // }));
    // stream = controller.outputStateStream;
    // stream.listen((event) {}, onDone: () {
    //   _loading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      noPadding: true,
      backgroundColor: Colors.black,
      appBar: AppHeader(
        textColor: Colors.white,
        text: learning.name,
        withBack: true,
        icon: 'download',
        iconDisabled: _loading,
        iconOnTap: () async {
          if (isImage(learning.link)) {
            if (kIsWeb) {
              try {
                // first we make a request to the url like you did
                // in the android and ios version
                final http.Response r =
                    await http.get(Uri.parse(learning.link));

                // we get the bytes from the body
                final data = r.bodyBytes;
                // and encode them to base64
                final base64data = base64Encode(data);
                html.AnchorElement anchorElement = new html.AnchorElement(
                    href: 'data:image/jpeg;base64,$base64data');
                anchorElement.download = "learning_photo";
                anchorElement.click();
                anchorElement.remove();
              } catch (e) {
                showErrorSnackbar(e.toString());
              }
            } else {
              await launchUrl(Uri.parse(learning.link),
                  mode: LaunchMode.externalApplication);
            }
          } else {
            await launchUrl(Uri.parse(learning.link),
                mode: LaunchMode.externalApplication);
          }
        },
      ),
      body: isImage(learning.link)
          ? PhotoView(imageProvider: _image)
          : Center(
              child: Text(
                'Невозможно отобразить изображение в приложении из-за неверной ссылки. \n\nПопробуйте загрузить изображение вручную.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
