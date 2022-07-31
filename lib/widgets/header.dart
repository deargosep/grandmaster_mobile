import 'package:flutter/material.dart';

import 'images/brand_icon.dart';

class Header extends StatelessWidget {
  Header(
      {Key? key,
      this.text,
      this.withPadding = true,
      this.withBack = true,
      this.icon = '',
      this.iconOnTap,
      this.padding,
      this.bottomChild,
      this.onTap})
      : super(key: key);
  final text;
  bool withPadding;
  bool withBack;
  final padding;
  String icon;
  Widget? bottomChild;
  final VoidCallback? onTap;
  final VoidCallback? iconOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        children: [
          Padding(
            padding: padding != null
                ? padding
                : withPadding
                    ? EdgeInsets.fromLTRB(
                        20, 10 + MediaQuery.of(context).viewInsets.top, 20, 0)
                    : EdgeInsets.all(0),
            child: Row(
              children: [
                !withBack
                    ? Container()
                    : Row(children: [
                        Container(
                          height: 17,
                          width: 10,
                          child: BrandIcon(
                            icon: 'back_arrow',
                            onTap: onTap,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        SizedBox(
                          width: 26,
                        ),
                      ]),
                Text(
                  text ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                Spacer(),
                icon != ''
                    ? Container(
                        height: 18,
                        width: 18,
                        child: BrandIcon(
                          icon: icon,
                          onTap: iconOnTap,
                          color: Theme.of(context).colorScheme.secondary,
                          height: 18,
                          width: 18,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          bottomChild != null ? Spacer() : Container(),
          bottomChild ?? Container()
        ],
      ),
    );
  }
}

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  AppHeader(
      {Key? key,
      this.text,
      this.withPadding = true,
      this.withBack = true,
      this.icon = '',
      this.iconOnTap,
      this.padding,
      this.bottomChild,
      this.onTap})
      : super(key: key);
  final text;
  bool withPadding;
  bool withBack;
  final padding;
  String icon;
  Widget? bottomChild;
  final VoidCallback? onTap;
  final VoidCallback? iconOnTap;

  @override
  final Size preferredSize = Size(64, 64); // default is 56.0

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding != null
              ? padding
              : withPadding
                  ? EdgeInsets.fromLTRB(
                      20, 40 + MediaQuery.of(context).viewInsets.top, 20, 0)
                  : EdgeInsets.all(0),
          child: Row(
            children: [
              !withBack
                  ? Container()
                  : Row(children: [
                      Container(
                        height: 17,
                        width: 10,
                        child: BrandIcon(
                          icon: 'back_arrow',
                          onTap: onTap,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      SizedBox(
                        width: 26,
                      ),
                    ]),
              Text(
                text ?? '',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              Spacer(),
              icon != ''
                  ? Container(
                      height: 18,
                      width: 18,
                      child: BrandIcon(
                        icon: icon,
                        onTap: iconOnTap,
                        color: Theme.of(context).colorScheme.secondary,
                        height: 18,
                        width: 18,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        Spacer(),
        bottomChild ?? Container()
      ],
    );
  }
}
