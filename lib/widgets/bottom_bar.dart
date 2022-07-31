import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';

class BottomBar extends StatelessWidget {
  BottomBar({Key? key, required this.onTap, required this.currentIndex})
      : super(key: key);
  Function(int) onTap;
  int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 8,
          blurRadius: 15,
          offset: Offset(0, 8),
        )
      ]),
      width: MediaQuery.of(context).size.width,
      height: 84,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(27, 16, 27, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  onTap(0);
                },
                child: BottomBarItem(icon: 'menu', active: currentIndex == 0)),
            Container(
              height: 52,
              width: 1,
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: Color(0xFF9FA6BA), width: 1))),
            ),
            GestureDetector(
                onTap: () {
                  onTap(1);
                },
                child: BottomBarItem(icon: 'home', active: currentIndex == 1)),
            GestureDetector(
                onTap: () {
                  onTap(2);
                },
                child: BottomBarItem(icon: 'chat', active: currentIndex == 2)),
            GestureDetector(
                onTap: () {
                  onTap(3);
                },
                child:
                    BottomBarItem(icon: 'profile', active: currentIndex == 3)),
          ],
        ),
      ),
    );
  }
}

class BottomBarItem extends StatelessWidget {
  BottomBarItem({Key? key, required this.icon, required this.active})
      : super(key: key);
  String icon;
  bool active;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BrandIcon(
            icon: icon,
            color: active ? Theme.of(context).primaryColor : Color(0xFF9FA6BA),
            width: 26,
            height: 26,
          ),
        ],
      ),
    );
  }
}

class NewEvent extends StatefulWidget {
  NewEvent({Key? key, required this.onTap}) : super(key: key);
  VoidCallback onTap;

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  bool pressing = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (dt) {
        setState(() {
          pressing = true;
        });
      },
      onTapUp: (dt) {
        setState(() {
          pressing = false;
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
        width: 75,
        decoration: BoxDecoration(
            color:
                pressing ? Color(0xFF2D34CB) : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BrandIcon(icon: 'add'),
            SizedBox(
              height: 6,
            ),
            Text(
              'Новое событие',
              style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
