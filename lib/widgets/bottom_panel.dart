import 'package:flutter/material.dart';

class BottomPanel extends StatelessWidget {
  const BottomPanel(
      {Key? key, required this.child, this.height, this.withShadow = true})
      : super(key: key);
  final child;
  final height;
  final bool withShadow;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          withShadow
              ? BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 15,
                  blurRadius: 15,
                  offset: Offset(0, 8),
                )
              : BoxShadow(color: Colors.transparent)
        ]),
        height: height,
        width: MediaQuery.of(context).size.width,
        // height: 83,
        child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 16),
            child: child));
  }
}
