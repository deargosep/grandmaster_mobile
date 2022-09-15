import 'package:flutter/material.dart';

class CircleLogo extends StatelessWidget {
  const CircleLogo({Key? key, this.height, this.width}) : super(key: key);
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: CircleAvatar(
          // backgroundColor: Colors.black12,
          child: Image.asset('assets/images/icon_ios.jpeg')
          // AssetImage('assets/images/icon_ios.jpeg'),
          ),
    );
  }
}
