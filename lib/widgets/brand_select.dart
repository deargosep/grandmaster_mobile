import 'dart:async';

import 'package:flutter/material.dart';

class BrandSelect extends StatefulWidget {
  BrandSelect({Key? key, required this.onChanged, required bool this.checked})
      : super(key: key);

  final onChanged;
  bool checked;

  @override
  State<BrandSelect> createState() => _BrandSelectState();
}

class _BrandSelectState extends State<BrandSelect>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 600), vsync: this)
    ..repeat(reverse: false);
  bool pressing = false;
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  Tween<double> _tween = Tween(begin: 1, end: 0.7);

  @override
  initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (pressing) {
        return Theme.of(context).primaryColor;
      } else {
        return Theme.of(context).primaryColor;
      }
    }

    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          pressing = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          pressing = false;
        });
      },
      onTapCancel: () {
        setState(() {
          pressing = false;
        });
      },
      onTap: () {
        setState(() {
          pressing = true;
        });
        Timer(Duration(milliseconds: 50), () {
          setState(() {
            pressing = false;
          });
        });
        widget.onChanged!();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100000)),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 1.5)),
            child: Builder(builder: (context) {
              if (widget.checked == true) {
                if (pressing) {
                  return ScaleTransition(
                      scale: _tween.animate(_animation),
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: getColor(),
                        ),
                      ));
                } else {
                  return Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: getColor(),
                    ),
                  );
                }
              }
              if (widget.checked == false) {
                if (pressing) {
                  return ScaleTransition(
                      scale: _tween.animate(_animation),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        height: 14,
                        width: 14,
                      ));
                } else {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    height: 14,
                    width: 14,
                  );
                }
              }
              return Container();
            })),
      ),
    );
  }
}
