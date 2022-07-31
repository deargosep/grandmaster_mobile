import 'package:flutter/material.dart';

class BrandButton extends StatefulWidget {
  final String text;
  final type;
  final disabled;
  final onPressed;
  final width;
  final textAlign;
  final textStyle;

  BrandButton(
      {Key? key,
      required String this.text,
      this.type = 'primary',
      this.onPressed,
      this.disabled = false,
      this.width,
      this.textAlign = 'center',
      this.textStyle})
      : super(key: key);

  @override
  State<BrandButton> createState() => _BrandButtonState();
}

class _BrandButtonState extends State<BrandButton> {
  bool pressing = false;
  @override
  Widget build(BuildContext context) {
    var style = widget.textStyle ??
        TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);
    Color getColor() {
      if (widget.disabled == true) {
        return Color(0xFF797A94);
      }
      switch (widget.type) {
        case 'primary':
          if (pressing) return Color(0xFF2D34CB);
          return Theme.of(context).primaryColor;
        case 'secondary':
          if (pressing) return Color(0xFF172548);
          return Color(0xFFA37F7F);
        default:
          return Theme.of(context).primaryColor;
      }
    }

    return GestureDetector(
        onTapUp: (details) {
          setState(() {
            pressing = false;
          });
        },
        onTapDown: (details) {
          setState(() {
            pressing = true;
          });
        },
        onTapCancel: () {
          setState(() {
            pressing = false;
          });
        },
        onTap: () {
          if (widget.disabled == true) {
            print('null');
            return null;
          } else {
            widget.onPressed();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: getColor(),
          ),
          width: widget.width ?? MediaQuery.of(context).size.width,
          height: 50,
          child: widget.textAlign == 'center'
              ? Center(
                  child: Text(
                  widget.text,
                  style: style,
                ))
              : widget.textAlign == 'left'
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16.5, 20, 16.5),
                      child: Text(
                        widget.text,
                        style: style,
                      ),
                    )
                  : Text(
                      widget.text,
                      style: style,
                    ),
        ));
  }
}
