import 'package:flutter/material.dart';

import 'images/brand_icon.dart';

class Option extends StatefulWidget {
  const Option(
      {Key? key, required this.text, this.onTap, this.type = 'secondary'})
      : super(key: key);
  final text;
  final onTap;
  final type;

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {
  var pressing = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (dt) {
        setState(() {
          pressing = false;
        });
      },
      onTapDown: (dt) {
        setState(() {
          pressing = true;
        });
      },
      onTapCancel: () {
        setState(() {
          pressing = false;
        });
      },
      onTap: widget.onTap,
      child: Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(20, 16.5, 20, 16.5),
        decoration: BoxDecoration(
          color:
              widget.type == 'primary' ? Color(0xFFFF5B5B) : Color(0xFFFBF7F7),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text ?? '',
              style: TextStyle(
                  color: widget.type == 'primary'
                      ? Colors.white
                      : Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            BrandIcon(
              icon: 'right_arrow',
              color: widget.type == 'primary'
                  ? Colors.white
                  : Theme.of(context).colorScheme.secondary,
              height: 14,
              width: 8,
            )
          ],
        ),
      ),
    );
  }
}
