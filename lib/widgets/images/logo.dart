import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key, this.bigSize = true}) : super(key: key);
  final bool bigSize;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/LOGO.svg',
      height: !bigSize ? 60 : null,
      width: !bigSize ? 215 : null,
    );
  }
}
