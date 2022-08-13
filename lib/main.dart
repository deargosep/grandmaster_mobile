import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/auth/auth.dart';
import 'package:grandmaster/screens/auth/code.dart';
import 'package:grandmaster/screens/members.dart';
import 'package:grandmaster/screens/menu/about/about.dart';
import 'package:grandmaster/screens/menu/about/add_about.dart';
import 'package:grandmaster/screens/menu/events/event_screen.dart';
import 'package:grandmaster/screens/menu/events/events.dart';
import 'package:grandmaster/screens/menu/groups/group.dart';
import 'package:grandmaster/screens/menu/groups/group_add.dart';
import 'package:grandmaster/screens/menu/groups/group_manage.dart';
import 'package:grandmaster/screens/menu/groups/groups.dart';
import 'package:grandmaster/screens/menu/journal/journal_groups.dart';
import 'package:grandmaster/screens/menu/journal/journal_places.dart';
import 'package:grandmaster/screens/menu/learnings/add_learning.dart';
import 'package:grandmaster/screens/menu/learnings/learnings.dart';
import 'package:grandmaster/screens/menu/payment/payment.dart';
import 'package:grandmaster/screens/menu/places/add_place.dart';
import 'package:grandmaster/screens/menu/places/place_screen.dart';
import 'package:grandmaster/screens/menu/places/places.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_edit.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_groups.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_places.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_table.dart';
import 'package:grandmaster/screens/menu/video/add_video.dart';
import 'package:grandmaster/screens/menu/video/videos.dart';
import 'package:grandmaster/screens/someone_profile.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/screens/tabs/home/add_edit_article.dart';
import 'package:grandmaster/screens/tabs/home/article_screen.dart';
import 'package:grandmaster/screens/tabs/home/select_trainers.dart';
import 'package:grandmaster/screens/tabs/profile/child_profile.dart';
import 'package:grandmaster/screens/tabs/profile/document.dart';
import 'package:grandmaster/screens/tabs/profile/documents.dart';
import 'package:grandmaster/screens/tabs/profile/my_profile.dart';
import 'package:grandmaster/screens/tabs/profile/profile.dart';
import 'package:grandmaster/screens/tabs/tabs.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/state/payments.dart';
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/state/user.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Articles()),
      ChangeNotifierProvider(create: (context) => UserState()),
      ChangeNotifierProvider(create: (context) => EventsState()),
      ChangeNotifierProvider(create: (context) => Places()),
      ChangeNotifierProvider(create: (context) => PaymentsState()),
      ChangeNotifierProvider(create: (context) => GroupsState()),
    ],
    child: GetMaterialApp(
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
            transition: Transition.noTransition),
        GetPage(
            name: '/add_edit_article',
            page: () => AddEditArticleScreen(),
            transition: Transition.noTransition),
        GetPage(name: '/chat', page: () => ChatScreen()),
        GetPage(
            name: '/members',
            page: () => MembersScreen(),
            transition: Transition.noTransition),
        GetPage(name: '/other_profile', page: () => SomeoneProfile()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(
            name: '/my_profile',
            page: () => MyProfileScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/my_profile/documents',
            page: () => DocumentsScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/my_profile/documents/document',
            page: () => DocumentScreen()),
        GetPage(name: '/child_profile', page: () => ChildProfileScreen()),
        GetPage(
            name: '/events',
            page: () => EventsScreen(),
            transition: Transition.noTransition),
        GetPage(name: '/event', page: () => EventScreen()),
        GetPage(
            name: '/videos',
            page: () => VideosScreen(),
            transition: Transition.noTransition),
        GetPage(
          name: '/videos/add',
          page: () => AddVideoScreen(),
        ),
        GetPage(
            name: '/learnings',
            page: () => LearningsScreen(),
            transition: Transition.noTransition),
        GetPage(
          name: '/learnings/add',
          page: () => AddLearningScreen(),
        ),
        GetPage(
            name: '/places',
            page: () => PlacesScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/place',
            page: () => PlaceScreen(),
            transition: Transition.noTransition),
        GetPage(
          name: '/places/add',
          page: () => AddPlace(),
        ),
        GetPage(
          name: '/places/add/trainers',
          page: () => SelectTrainersScreen(),
        ),
        GetPage(
            name: '/payment',
            page: () => PaymentScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/groups',
            page: () => GroupsScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/group',
            page: () => GroupScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/group/manage',
            page: () => GroupManageScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/groups/add',
            page: () => GroupAddScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/about',
            page: () => AboutScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/about/add',
            page: () => AddAboutScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/schedule',
            page: () => PlacesScheduleScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/schedule/groups',
            page: () => GroupsScheduleScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/schedule/table',
            page: () => TableScheduleScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/schedule/edit',
            page: () => EditScheduleScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/journal',
            page: () => PlacesJournalScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/journal/groups',
            page: () => GroupsJournalScreen(),
            transition: Transition.noTransition),
        GetPage(
            name: '/journal/table',
            page: () => GroupsScheduleScreen(),
            transition: Transition.noTransition),
      ],
      theme: ThemeClass.lightTheme,
    ),
  ));
}
