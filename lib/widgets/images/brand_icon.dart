import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:universal_html/html.dart' as html;

class BrandIcon extends StatelessWidget {
  BrandIcon(
      {Key? key,
      required this.icon,
      Color? this.color,
      this.width,
      this.height,
      this.fit,
      this.onTapCalendar,
      this.disabled = false,
      this.onTap})
      : super(key: key);
  String icon;
  Color? color;
  double? width;
  double? height;
  bool disabled;
  final fit;
  final onTapCalendar;
  final onTap;

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    if (icon == 'calendar')
      return InkWell(
        onTap: () async {
          if (onTap != null) onTap();
          if (onTapCalendar != null) {
            final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(1950, 1),
                lastDate: DateTime(2045));
            if (picked != null && picked != selectedDate) {
              onTapCalendar("${picked.day}.${picked.month}.${picked.year}");
            }
          }
        },
        child: SvgPicture.asset(
          'assets/icons/${icon}.svg',
          fit: fit ?? BoxFit.contain,
          color: color ?? Theme.of(context).primaryColor,
          height: height,
          width: width,
        ),
      );
    if (icon == 'back_arrow') {
      return Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: IconButton(
          constraints: BoxConstraints(maxWidth: 40),
          padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
          onPressed: () {
            if (onTap != null) onTap();
            Get.back();
          },
          icon: SimpleShadow(
            opacity: 0.3,
            offset: Offset(0.5, 1),
            color: Theme.of(context).colorScheme.secondary,
            child: SvgPicture.asset(
              'assets/icons/${icon}.svg',
              fit: fit ?? BoxFit.contain,
              color: color ?? Theme.of(context).primaryColor,
              height: height,
              width: width,
            ),
          ),
        ),
      );
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (onTap != null) onTap();
          Get.back();
        },
        child: Container(
          width: 30,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              'assets/icons/${icon}.svg',
              fit: fit ?? BoxFit.contain,
              color: color ?? Theme.of(context).primaryColor,
              height: height,
              width: width,
            ),
          ),
        ),
      );
    }
    if (kIsWeb &&
        icon == 'download' &&
        html.window.matchMedia('(display-mode: standalone)').matches) {
      return Opacity(
          opacity: 0.7,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              showErrorSnackbar(
                  'Перейдите в версию для браузера или в мобильное приложение для скачивания');
            },
            child: SvgPicture.asset(
              'assets/icons/${icon}.svg',
              color: color ?? Theme.of(context).primaryColor,
              height: height,
              width: width,
            ),
          ));
    }
    return Opacity(
      opacity: disabled ? 0.7 : 1,
      child: onTap != null
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (!disabled) {
                  onTap();
                }
              },
              child: SvgPicture.asset(
                'assets/icons/${icon}.svg',
                color: color ?? Theme.of(context).primaryColor,
                height: height,
                width: width,
              ),
            )
          : SvgPicture.asset(
              'assets/icons/${icon}.svg',
              color: color ?? Theme.of(context).primaryColor,
              height: height,
              width: width,
            ),
    );
  }
}
