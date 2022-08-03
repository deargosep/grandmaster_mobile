import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/add_edit_article.dart';
import 'package:grandmaster/screens/auth/auth.dart';
import 'package:grandmaster/screens/auth/code.dart';
import 'package:grandmaster/screens/event_screen.dart';
import 'package:grandmaster/screens/members.dart';
import 'package:grandmaster/screens/someone_profile.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/screens/tabs/profile/child_profile.dart';
import 'package:grandmaster/screens/tabs/profile/document.dart';
import 'package:grandmaster/screens/tabs/profile/documents.dart';
import 'package:grandmaster/screens/tabs/profile/my_profile.dart';
import 'package:grandmaster/screens/tabs/profile/profile.dart';
import 'package:grandmaster/screens/tabs/tabs.dart';
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/state/user.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Articles()),
      ChangeNotifierProvider(create: (context) => UserState()),
    ],
    child: GetMaterialApp(
      getPages: [
        // auth
        GetPage(name: '/', page: () => AuthRegisterScreen()),
        GetPage(name: '/code', page: () => InputCodeScreen()),
        // tabs
        GetPage(name: '/bar', page: () => BarScreen()),
        GetPage(name: '/article', page: () => EventScreen()),
        GetPage(name: '/add_edit_article', page: () => AddEditArticleScreen()),
        GetPage(name: '/chat', page: () => ChatScreen()),
        GetPage(name: '/members', page: () => MembersScreen()),
        GetPage(name: '/other_profile', page: () => SomeoneProfile()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(name: '/my_profile', page: () => MyProfileScreen()),
        GetPage(name: '/my_profile/documents', page: () => DocumentsScreen()),
        GetPage(
            name: '/my_profile/documents/document',
            page: () => DocumentScreen()),
        GetPage(name: '/child_profile', page: () => ChildProfileScreen()),
      ],
      theme: ThemeClass.lightTheme,
    ),
  ));
}
