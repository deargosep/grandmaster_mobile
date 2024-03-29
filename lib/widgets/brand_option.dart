import 'package:flutter/material.dart';

import 'images/brand_icon.dart';

class Option extends StatefulWidget {
  const Option(
      {Key? key,
      required this.text,
      this.onTap,
      this.type = 'secondary',
      this.mark,
      this.noArrow = false,
      this.red = false})
      : super(key: key);
  final text;
  final onTap;
  final type;
  final bool? mark;
  final bool noArrow;
  final bool red;

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
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: getColor('container'),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            widget.mark != null
                ? widget.mark!
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: BrandIcon(
                          icon: 'check',
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : Container()
                : Container(),
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
            Expanded(
              child: Text(
                widget.text ?? '',
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                    color: widget.red
                        ? Theme.of(context).primaryColor
                        : getColor('text'),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
            widget.type != 'create' && !widget.noArrow
                ? SizedBox(
                    width: 16,
                  )
                : Container(),
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
