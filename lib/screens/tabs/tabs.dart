import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chats.dart';
import 'package:grandmaster/screens/tabs/home/home.dart';
import 'package:grandmaster/screens/tabs/menu/menu.dart';
import 'package:grandmaster/screens/tabs/profile/profile.dart';
import 'package:grandmaster/widgets/bottom_bar.dart';

class BarScreen extends StatefulWidget {
  const BarScreen({Key? key}) : super(key: key);

  @override
  State<BarScreen> createState() => _BarScreenState();
}

class _BarScreenState extends State<BarScreen> {
  int _selectedIndex = Get.arguments ?? 0;
  static const List<Widget> _tabs = <Widget>[
    MenuScreen(),
    //Home
    HomeScreen(),
    //Chat
    ChatsScreen(),
    //Profile
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Platform.operatingSystem == 'ios'
            ? Brightness.dark
            : Brightness.light));
    return Scaffold(
        // backgroundColor: Color(0xFFEAEAEA),
        body: Center(
          child: _tabs.elementAt(_selectedIndex),
        ),
        bottomNavigationBar:
            BottomBar(onTap: _onItemTapped, currentIndex: _selectedIndex)
        // BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   iconSize: 20,
        //   selectedFontSize: 8.0,
        //   unselectedFontSize: 8.0,
        //   selectedItemColor: Theme.of(context).primaryColor,
        //   unselectedItemColor: Color(0xFF9FA6BA),
        //   enableFeedback: true,
        //   elevation: 0.0,
        //   currentIndex: _selectedIndex,
        //   items: items,
        //   onTap: _onItemTapped,
        // ),
        );
  }
}
