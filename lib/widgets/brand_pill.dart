import 'package:flutter/material.dart';

class BrandPill extends StatelessWidget {
  BrandPill(this.timeDateEnd, {Key? key}) : super(key: key);
  final timeDateEnd;
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondaryContainer;
    bool isEnded(DateTime end) {
      return DateTime.now().isAfter(end);
    }

    return Container(
      height: 26,
      width: 89,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Theme.of(context).inputDecorationTheme.fillColor),
      child: Center(
        child: Text(
          isEnded(timeDateEnd) ? 'Закрытое' : 'Открытое',
          style: TextStyle(
              color: color, fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ),
    );
  }
}
