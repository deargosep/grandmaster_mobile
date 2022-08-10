import 'dart:async';

import 'package:flutter/material.dart';

class BrandCheckbox extends StatefulWidget {
  BrandCheckbox(
      {Key? key,
      bool? this.valid,
      VoidCallback? this.onChanged,
      required bool this.checked,
      this.noSquare})
      : super(key: key);

  bool? valid;
  VoidCallback? onChanged;
  bool checked;
  final noSquare;

  @override
  State<BrandCheckbox> createState() => _BrandCheckboxState();
}

class _BrandCheckboxState extends State<BrandCheckbox>
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
      switch (widget.valid) {
        default:
          if (pressing) return Theme.of(context).colorScheme.secondary;
          return Theme.of(context).colorScheme.secondary;
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
      child: Container(
          height: 22,
          width: 22,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                  color: Theme.of(context).colorScheme.secondary, width: 1.5)),
          child: Builder(builder: (context) {
            if (widget.checked == false) {
              if (pressing) {
                return ScaleTransition(
                    scale: _tween.animate(_animation),
                    child: Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        color: getColor(),
                      ),
                    ));
              } else {
                return Container();
              }
            }
            if (widget.checked == true) {
              if (pressing) {
                return ScaleTransition(
                  scale: _tween.animate(_animation),
                  child: Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      color: getColor(),
                    ),
                  ),
                );
              } else {
                return Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: getColor(),
                  ),
                );
              }
            }
            return Container();
          })),
    );
  }
}
