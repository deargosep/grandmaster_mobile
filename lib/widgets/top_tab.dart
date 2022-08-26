import 'package:flutter/material.dart';

class TopTab extends StatelessWidget {
  const TopTab({Key? key, this.text}) : super(key: key);
  final text;
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        width: 167,
        height: 40,
        child: Center(
            child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        )),
      ),
    );
  }
}
