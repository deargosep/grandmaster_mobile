import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:simple_shadow/simple_shadow.dart';

class BrandIcon extends StatelessWidget {
  BrandIcon(
      {Key? key,
      required this.icon,
      Color? this.color,
      this.width,
      this.height,
      this.fit,
      this.onTapCalendar,
      this.onTap})
      : super(key: key);
  final icon;
  Color? color;
  double? width;
  double? height;
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
          final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(1950, 1),
              lastDate: DateTime(2045));
          if (picked != null && picked != selectedDate) {
            onTapCalendar("${picked.day}.${picked.month}.${picked.year}");
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
    return onTap != null
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              onTap();
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
          );
  }
}
