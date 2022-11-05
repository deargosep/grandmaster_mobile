import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';

class BrandButton extends StatefulWidget {
  final String text;
  final type;
  bool disabled;
  final onPressed;
  final double? width;
  final Alignment textAlign;
  final TextStyle? textStyle;
  final String? icon;
  final Color? iconColor;
  final bool isLoaded;

  BrandButton(
      {Key? key,
      required this.text,
      this.type = 'primary',
      this.onPressed,
      this.disabled = false,
      this.isLoaded = true,
      this.width,
      this.textAlign = Alignment.center,
      this.textStyle,
      this.icon,
      this.iconColor})
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
          // if (pressing) return Color(0xFF2D34CB);
          return Theme.of(context).primaryColor;
        case 'secondary':
          // if (pressing) return Color(0xFF172548);
          return Color(0xFFA37F7F);
        case 'info':
          return Theme.of(context).inputDecorationTheme.fillColor!;
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
          if (widget.disabled == true || !widget.isLoaded) {
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
            child: widget.icon != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      BrandIcon(
                        icon: widget.icon!,
                        color: widget.iconColor,
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        widget.text,
                        style: style,
                      ),
                      Spacer()
                    ],
                  )
                : !widget.isLoaded
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 11,
                          ),
                          Text(
                            widget.text,
                            style: style,
                          ),
                          Spacer()
                        ],
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.text,
                          style: style,
                        ))));
  }
}

// GestureDetector(
// onTap: !isLoaded
// ? null
//     : () {
// setState(() {
// isLoaded = false;
// });
// createDio()
//     .get('/chats/${user.chatId}/')
//     .then((value) {
// Provider.of<ChatsState>(context,
// listen: false)
//     .setChats(
// childId: Provider.of<UserState>(
// context,
// listen: false)
//     .childId)
//     .then((value) {
// if (mounted)
// setState(() {
// isLoaded = true;
// });
// Get.toNamed('/chat',
// arguments: Provider.of<ChatsState>(
// context,
// listen: false)
//     .chats
//     .firstWhere((element) =>
// element.id == user.chatId));
// });
// });
// },
// child: Container(
// height: 40,
// decoration: BoxDecoration(
// color: Color(0xFFFBF7F7),
// borderRadius:
// BorderRadius.all(Radius.circular(100))),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// !isLoaded
// ? Container(
// height: 20,
// width: 20,
// margin:
// const EdgeInsets.only(right: 20),
// child: CircularProgressIndicator(),
// )
// : Container(),
// Text(
// 'Написать сообщение',
// style: TextStyle(
// color: Theme.of(context)
// .colorScheme
//     .secondary,
// fontWeight: FontWeight.w500,
// fontSize: 16),
// ),
// ],
// ),
// ),
// ),
