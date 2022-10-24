import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

class BottomBarWrap extends StatefulWidget {
  const BottomBarWrap({Key? key, required int this.currentTab})
      : super(key: key);
  final int currentTab;

  @override
  State<BottomBarWrap> createState() => _BottomBarWrapState();
}

class _BottomBarWrapState extends State<BottomBarWrap> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentTab;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Get.offAllNamed('/bar', arguments: index);
    if (index == 2) {
      Provider.of<ChatsState>(context, listen: false).setChats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomBar(onTap: _onItemTapped, currentIndex: _selectedIndex);
  }
}
