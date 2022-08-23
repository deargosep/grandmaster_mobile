import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get.dart';
import 'package:grandmaster/screens/auth/auth.dart';
import 'package:grandmaster/screens/auth/code.dart';
import 'package:grandmaster/screens/fail.dart';
import 'package:grandmaster/screens/members.dart';
import 'package:grandmaster/screens/menu/about/about.dart';
import 'package:grandmaster/screens/menu/about/add_edit_about.dart';
import 'package:grandmaster/screens/menu/events/add_event.dart';
import 'package:grandmaster/screens/menu/events/event_screen.dart';
import 'package:grandmaster/screens/menu/events/events.dart';
import 'package:grandmaster/screens/menu/events/list.dart';
import 'package:grandmaster/screens/menu/groups/group.dart';
import 'package:grandmaster/screens/menu/groups/group_create.dart';
import 'package:grandmaster/screens/menu/groups/group_manage.dart';
import 'package:grandmaster/screens/menu/groups/groups.dart';
import 'package:grandmaster/screens/menu/journal/journal_groups.dart';
import 'package:grandmaster/screens/menu/journal/journal_log.dart';
import 'package:grandmaster/screens/menu/journal/journal_mark.dart';
import 'package:grandmaster/screens/menu/journal/journal_places.dart';
import 'package:grandmaster/screens/menu/learnings/add_edit_learning.dart';
import 'package:grandmaster/screens/menu/learnings/learnings.dart';
import 'package:grandmaster/screens/menu/payment/payment.dart';
import 'package:grandmaster/screens/menu/places/add_edit_place.dart';
import 'package:grandmaster/screens/menu/places/place_screen.dart';
import 'package:grandmaster/screens/menu/places/places.dart';
import 'package:grandmaster/screens/menu/places/select_trainers.dart';
import 'package:grandmaster/screens/menu/qr/qr.dart';
import 'package:grandmaster/screens/menu/qr/qr_events.dart';
import 'package:grandmaster/screens/menu/qr/qr_partners.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_edit.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_groups.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_places.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_table.dart';
import 'package:grandmaster/screens/menu/video/add_edit_video.dart';
import 'package:grandmaster/screens/menu/video/videos.dart';
import 'package:grandmaster/screens/someone_profile.dart';
import 'package:grandmaster/screens/success.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/screens/tabs/home/add_edit_article.dart';
import 'package:grandmaster/screens/tabs/home/article_screen.dart';
import 'package:grandmaster/screens/tabs/profile/child_profile.dart';
import 'package:grandmaster/screens/tabs/profile/document.dart';
import 'package:grandmaster/screens/tabs/profile/documents.dart';
import 'package:grandmaster/screens/tabs/profile/my_profile.dart';
import 'package:grandmaster/screens/tabs/profile/profile.dart';
import 'package:grandmaster/screens/tabs/tabs.dart';
import 'package:grandmaster/state/about.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/state/learnings.dart';
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/state/payments.dart';
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/state/videos.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  initializeDateFormatting('ru_RU', null);
  Intl.defaultLocale = 'ru_RU';
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Articles()),
      ChangeNotifierProvider(create: (context) => UserState()),
      ChangeNotifierProvider(create: (context) => EventsState()),
      ChangeNotifierProvider(create: (context) => PlacesState()),
      ChangeNotifierProvider(create: (context) => PaymentsState()),
      ChangeNotifierProvider(create: (context) => GroupsState()),
      ChangeNotifierProvider(create: (context) => VideosState()),
      ChangeNotifierProvider(create: (context) => AboutState()),
      ChangeNotifierProvider(create: (context) => LearningsState()),
    ],
    child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      transitionDuration: Duration.zero,
      getPages: [
        // auth
        GetPage(name: '/', page: () => AuthRegisterScreen()),
        GetPage(name: '/code', page: () => InputCodeScreen()),
        // tabs
        GetPage(name: '/bar', page: () => BarScreen()),
        GetPage(
          name: '/article',
          page: () => ArticleScreen(),
        ),
        GetPage(
          name: '/add_edit_article',
          page: () => AddEditArticleScreen(),
        ),
        GetPage(name: '/chat', page: () => ChatScreen()),
        GetPage(
          name: '/members',
          page: () => MembersScreen(),
        ),
        GetPage(name: '/other_profile', page: () => SomeoneProfile()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(
          name: '/my_profile',
          page: () => MyProfileScreen(),
        ),
        GetPage(
          name: '/my_profile/documents',
          page: () => DocumentsScreen(),
        ),
        GetPage(
            name: '/my_profile/documents/document',
            page: () => DocumentScreen()),
        GetPage(name: '/child_profile', page: () => ChildProfileScreen()),
        GetPage(
          name: '/events',
          page: () => EventsScreen(),
        ),
        GetPage(
          name: '/events/list',
          page: () => EventMembersListScreen(),
        ),
        GetPage(
          name: '/events/add',
          page: () => AddEventScreen(),
        ),
        GetPage(name: '/event', page: () => EventScreen()),
        GetPage(
          name: '/videos',
          page: () => VideosScreen(),
        ),
        GetPage(
          name: '/videos/add',
          page: () => AddEditVideoScreen(),
        ),
        GetPage(
          name: '/learnings',
          page: () => LearningsScreen(),
        ),
        GetPage(
          name: '/learnings/add',
          page: () => AddEditLearningScreen(),
        ),
        GetPage(
          name: '/places',
          page: () => PlacesScreen(),
        ),
        GetPage(
          name: '/place',
          page: () => PlaceScreen(),
        ),
        GetPage(
          name: '/places/add',
          page: () => AddEditPlace(),
        ),
        GetPage(
          name: '/places/add/trainers',
          page: () => SelectTrainersScreen(),
        ),
        GetPage(
          name: '/payment',
          page: () => PaymentScreen(),
        ),
        GetPage(
          name: '/groups',
          page: () => GroupsScreen(),
        ),
        GetPage(
          name: '/group',
          page: () => GroupScreen(),
        ),
        GetPage(
          name: '/group/manage',
          page: () => GroupManageScreen(),
        ),
        GetPage(
          name: '/groups/add',
          page: () => GroupAddScreen(),
        ),
        GetPage(
          name: '/about',
          page: () => AboutScreen(),
        ),
        GetPage(
          name: '/about/add',
          page: () => AddEditAboutScreen(),
        ),
        GetPage(
          name: '/schedule',
          page: () => PlacesScheduleScreen(),
        ),
        GetPage(
          name: '/schedule/groups',
          page: () => GroupsScheduleScreen(),
        ),
        GetPage(
          name: '/schedule/table',
          page: () => TableScheduleScreen(),
        ),
        GetPage(
          name: '/schedule/edit',
          page: () => EditScheduleScreen(),
        ),
        GetPage(
          name: '/journal',
          page: () => PlacesJournalScreen(),
        ),
        GetPage(
          name: '/journal/groups',
          page: () => GroupsJournalScreen(),
        ),
        GetPage(
          name: '/journal/mark',
          page: () => MarkJournalScreen(),
        ),
        GetPage(
          name: '/journal/log',
          page: () => LogJournalScreen(),
        ),
        GetPage(
          name: '/success',
          page: () => SuccessScreen(),
        ),
        GetPage(
          name: '/fail',
          page: () => FailScreen(),
        ),
        GetPage(
          name: '/qr',
          page: () => QRScreen(),
        ),
        GetPage(
          name: '/qr/events',
          page: () => QREvents(),
        ),
        GetPage(
          name: '/qr/partners',
          page: () => QRPartners(),
        ),
      ],
      theme: ThemeClass.lightTheme,
    ),
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        final isValidHost = ["app.grandmaster.center"]
            .contains(host); // <-- allow only hosts in array
        return isValidHost;
      });
  }
}
