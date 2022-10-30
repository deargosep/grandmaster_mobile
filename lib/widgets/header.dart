import 'package:flutter/foundation.dart';
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
      this.onTap,
      this.textColor})
      : super(key: key);
  final text;
  bool withPadding;
  bool withBack;
  final padding;
  String? icon;
  final VoidCallback? onTap;
  final VoidCallback? iconOnTap;
  final Color? textColor;

  @override
  final Size preferredSize = Size(56, 66); // default is 56.0

  @override
  Widget build(BuildContext context) {
    EdgeInsets myPadding = EdgeInsets.fromLTRB(withBack ? 10 : 20, 10, 20, 0);

    if (!kIsWeb) {
      myPadding = EdgeInsets.fromLTRB(
          withBack ? 10 : 20, MediaQuery.of(context).viewPadding.top, 20, 0);
    }
    return Padding(
      padding: myPadding,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            !withBack
                ? Container()
                : BrandIcon(
                    icon: 'back_arrow',
                    onTap: onTap,
                    height: 17,
                    width: 10,
                    color: textColor ?? Theme.of(context).colorScheme.secondary,
                  ),
            Expanded(
              child: Text(
                text ?? '',
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color:
                        textColor ?? Theme.of(context).colorScheme.secondary),
              ),
            ),
            icon != '' ? Spacer() : Container(),
            icon != ''
                ? BrandIcon(
                    icon: icon,
                    onTap: iconOnTap,
                    color: Theme.of(context).colorScheme.secondary,
                    height: 18,
                    width: 30,
                  )
                : Container()
          ],
        ),
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
      this.onTap,
      this.iconDisabled = false,
      this.textColor})
      : super(key: key);
  final text;
  bool withPadding;
  bool withBack;
  final padding;
  String? icon;
  bool iconDisabled;
  final VoidCallback? onTap;
  final VoidCallback? iconOnTap;
  final Color? textColor;

  @override
  final Size preferredSize = Size(56, 66); // default is 56.0

  @override
  Widget build(BuildContext context) {
    EdgeInsets myPadding = EdgeInsets.fromLTRB(withBack ? 10 : 20, 10, 20, 0);

    if (!kIsWeb) {
      myPadding = EdgeInsets.fromLTRB(
          withBack ? 10 : 20, MediaQuery.of(context).viewPadding.top, 20, 0);
    }
    return Padding(
      padding: myPadding,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          children: [
            !withBack
                ? Container()
                : BrandIcon(
                    icon: 'back_arrow',
                    onTap: onTap,
                    height: 17,
                    width: 10,
                    color: textColor ?? Theme.of(context).colorScheme.secondary,
                  ),
            Expanded(
              child: Text(
                text ?? '',
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color:
                        textColor ?? Theme.of(context).colorScheme.secondary),
              ),
            ),
            // icon != '' ? Spacer() : Container(),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon != ''
                      ? BrandIcon(
                          icon: icon,
                          onTap: iconOnTap,
                          color: textColor ??
                              Theme.of(context).colorScheme.secondary,
                          height: 18,
                          width: 30,
                          disabled: iconDisabled,
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
