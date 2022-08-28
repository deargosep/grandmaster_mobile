import 'package:flutter/material.dart';

import 'images/brand_icon.dart';

class Option extends StatefulWidget {
  const Option(
      {Key? key,
      required this.text,
      this.onTap,
      this.type = 'secondary',
      this.noArrow = false})
      : super(key: key);
  final text;
  final onTap;
  final type;
  final bool noArrow;

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {
  var pressing = false;
  @override
  Widget build(BuildContext context) {
    Color getColor(String colorType) {
      switch (widget.type) {
        case 'primary':
          if (colorType == 'container') return Color(0xFFFF5B5B);
          if (colorType == 'text') return Colors.white;
          return Colors.black;
        case 'secondary':
          if (colorType == 'container') return Color(0xFFFBF7F7);
          if (colorType == 'text') {
            return Theme.of(context).colorScheme.secondary;
          }
          return Colors.black;
        case 'create':
          if (colorType == 'container') return Color(0xFFFF5B5B);
          if (colorType == 'text') {
            return Colors.white;
          }
          return Colors.black;
        default:
          if (colorType == 'container') return Color(0xFFFBF7F7);
          if (colorType == 'text') {
            return Theme.of(context).colorScheme.secondary;
          }
          return Colors.black;
      }
    }

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
        height: 60,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: getColor('container'),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            widget.type == 'create'
                ? BrandIcon(
                    icon: 'add',
                    color: getColor('text'),
                    height: 14,
                    width: 14,
                  )
                : Container(),
            widget.type == 'create'
                ? SizedBox(
                    width: 10,
                  )
                : Container(),
            Container(
              child: Text(
                widget.text ?? '',
                maxLines: 1,
                // overflow: TextOverflow.clip,
                softWrap: false,
                style: TextStyle(
                    color: getColor('text'),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
            widget.type != 'create' ? Spacer() : Container(),
            widget.type != 'create' && !widget.noArrow
                ? BrandIcon(
                    icon: 'right_arrow',
                    color: getColor('text'),
                    height: 14,
                    width: 14,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
