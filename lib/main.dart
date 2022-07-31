import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/auth/auth.dart';
import 'package:grandmaster/screens/auth/code.dart';
import 'package:grandmaster/screens/event_screen.dart';
import 'package:grandmaster/screens/members.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/screens/tabs/tabs.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/user.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Articles()),
      ChangeNotifierProvider(create: (context) => User()),
    ],
    child: GetMaterialApp(
      getPages: [
        // auth
        GetPage(name: '/', page: () => AuthRegisterScreen()),
        GetPage(name: '/code', page: () => InputCodeScreen()),
        // tabs
        GetPage(name: '/bar', page: () => BarScreen()),
        GetPage(name: '/article', page: () => EventScreen()),
        GetPage(name: '/chat', page: () => ChatScreen()),
        GetPage(name: '/members', page: () => MembersScreen()),
      ],
      theme: ThemeClass.lightTheme,
    ),
  ));
}
