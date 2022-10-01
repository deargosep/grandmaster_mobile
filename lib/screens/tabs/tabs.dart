import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chats.dart';
import 'package:grandmaster/screens/tabs/home/home.dart';
import 'package:grandmaster/screens/tabs/menu/menu.dart';
import 'package:grandmaster/screens/tabs/profile/profile.dart';
import 'package:grandmaster/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../state/user.dart';
import '../../utils/custom_scaffold.dart';
import '../../utils/dio.dart';
import 'menu/menu.dart';

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
    if (index == 3) {
      createDio().get('/users/self/').then((value) {
        if (isValidContactType(value.data["contact_type"])) {
          Provider.of<UserState>(context, listen: false).setUser(value.data);
          setState(() {
            _selectedIndex = index;
          });
        }
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SharedPreferences.getInstance().then((value) {
        var access = value.getString('access');
        User user = Provider.of<UserState>(context, listen: false).user;
        print(access);
        if (access != null && user.role == 'guest') {
          Get.offAllNamed('/');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        noPadding: true,
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
