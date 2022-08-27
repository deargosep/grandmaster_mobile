import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key, this.bigSize = true, this.height, this.width})
      : super(key: key);
  final bool bigSize;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/LOGO.svg',
      height: !bigSize ? height ?? 60 : null,
      width: !bigSize ? width ?? 215 : null,
    );
  }
}
