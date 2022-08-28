import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:get/get.dart' hide Response;
import 'package:get/get.dart';
import 'package:grandmaster/screens/auth/auth.dart';
import 'package:grandmaster/screens/auth/code.dart';
import 'package:grandmaster/screens/fail.dart';
import 'package:grandmaster/screens/members.dart';
import 'package:grandmaster/screens/menu/about/about.dart';
import 'package:grandmaster/screens/menu/about/add_edit_about.dart';
import 'package:grandmaster/screens/menu/events/add_edit_event.dart';
import 'package:grandmaster/screens/menu/events/event_screen.dart';
import 'package:grandmaster/screens/menu/events/events.dart';
import 'package:grandmaster/screens/menu/events/sportsmens_list.dart';
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
import 'package:grandmaster/screens/menu/qr/qr_user.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_edit.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_groups.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_places.dart';
import 'package:grandmaster/screens/menu/schedule/schedule_table.dart';
import 'package:grandmaster/screens/menu/video/add_edit_video.dart';
import 'package:grandmaster/screens/menu/video/videos.dart';
import 'package:grandmaster/screens/menu/video/watch.dart';
import 'package:grandmaster/screens/someone_profile.dart';
import 'package:grandmaster/screens/success.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/screens/tabs/chat/chat_create.dart';
import 'package:grandmaster/screens/tabs/chat/chat_photo.dart';
import 'package:grandmaster/screens/tabs/chat/folder.dart';
import 'package:grandmaster/screens/tabs/home/add_edit_article.dart';
import 'package:grandmaster/screens/tabs/home/article_photos.dart';
import 'package:grandmaster/screens/tabs/home/article_screen.dart';
import 'package:grandmaster/screens/tabs/profile/child_profile.dart';
import 'package:grandmaster/screens/tabs/profile/document.dart';
import 'package:grandmaster/screens/tabs/profile/document_watch.dart';
import 'package:grandmaster/screens/tabs/profile/documents.dart';
import 'package:grandmaster/screens/tabs/profile/my_profile.dart';
import 'package:grandmaster/screens/tabs/profile/profile.dart';
import 'package:grandmaster/screens/tabs/tabs.dart';
import 'package:grandmaster/state/about.dart';
import 'package:grandmaster/state/chats.dart';
import 'package:grandmaster/state/events.dart';
import 'package:grandmaster/state/groups.dart';
import 'package:grandmaster/state/learnings.dart';
import 'package:grandmaster/state/news.dart';
import 'package:grandmaster/state/payments.dart';
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/state/schedule.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/state/videos.dart';
import 'package:grandmaster/state/visit_log.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'theme/theme.dart';

bool _initialUriIsHandled = false;

void main() {
  // if (kIsWeb) {
  //   setPathUrlStrategy();
  // }
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  initializeDateFormatting('ru_RU', null);
  Intl.defaultLocale = 'ru_RU';
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;

  StreamSubscription? _sub;

  final _scaffoldKey = GlobalKey();
  final _cmds = getCmds();
  final _cmdStyle = const TextStyle(
      fontFamily: 'Courier', fontSize: 12.0, fontWeight: FontWeight.w700);

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        if (uri != null && uri.queryParameters["user"] != null) {
          createDio(errHandler: (err, handler) {
            showErrorSnackbar('Not found');
          }).get('/users/${uri.queryParameters["user"]}/').then((value) {
            print(value);
            User user = UserState().convertMapToUser(value.data);
            if (uri.queryParameters["type"] == 'event') {
              Get.toNamed('/other_profile/passport', arguments: user);
            } else {
              Get.toNamed('/qr/user', arguments: user);
            }
          });
        }
        setState(() {
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    } else {
      print(Uri.base);
      if (Uri.base.queryParameters["type"] != null) {
        var uri = Uri.base;
        var userId = uri.queryParameters["user"];
        var type = uri.queryParameters["type"];
        createDio(errHandler: (err, handler) {
          showErrorSnackbar('Not found');
        }).get('/users/${userId}/').then((value) {
          print(value);
          User user = UserState().convertMapToUser(value.data);
          if (type == 'event') {
            Get.toNamed('/other_profile/passport', arguments: user);
          } else {
            Get.toNamed('/qr/user', arguments: user);
          }
        });
      }
    }
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    if (!kIsWeb) {
      // In this example app this is an almost useless guard, but it is here to
      // show we are not going to call getInitialUri multiple times, even if this
      // was a weidget that will be disposed of (ex. a navigation route change).
      if (!_initialUriIsHandled) {
        _initialUriIsHandled = true;
        // Get.snackbar('_handleInitialUri called', '');
        try {
          final uri = await getInitialUri();
          if (uri == null) {
            print('no initial uri');
          } else {
            print('got initial uri: ${uri}');
            if (uri.queryParameters["user"] != null) {
              createDio(errHandler: (err, handler) {
                showErrorSnackbar('Not found');
              }).get('/users/${uri.queryParameters["user"]}/').then((value) {
                print(value);
                User user = UserState().convertMapToUser(value.data);
                if (uri.queryParameters["type"] == 'event') {
                  Get.toNamed('/other_profile/passport', arguments: user);
                } else {
                  Get.toNamed('/qr/user', arguments: user);
                }
              });
            }
          }
          if (!mounted) return;
          setState(() => _initialUri = uri);
        } on PlatformException {
          // Platform messages may fail but we ignore the exception
          print('falied to get initial uri');
        } on FormatException catch (err) {
          if (!mounted) return;
          print('malformed initial uri');
          setState(() => _err = err);
        }
      }
    } else {
      if (Uri.base.queryParameters["type"] != null) {
        var uri = Uri.base;
        var userId = uri.queryParameters["user"];
        var type = uri.queryParameters["type"];
        createDio(errHandler: (err, handler) {
          showErrorSnackbar('Not found');
        }).get('/users/${userId}/').then((value) {
          print(value);
          User user = UserState().convertMapToUser(value.data);
          if (type == 'event') {
            Get.toNamed('/other_profile/passport', arguments: user);
          } else {
            Get.toNamed('/qr/user', arguments: user);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
        ChangeNotifierProvider(create: (context) => VisitLogState()),
        ChangeNotifierProvider(create: (context) => ScheduleState()),
        ChangeNotifierProvider(create: (context) => ChatsState()),
      ],
      child: GetMaterialApp(
        title: 'Grandmaster',
        // onGenerateRoute: (settings) {
        //   print(settings);
        //   if (settings.name != null) {
        //     if (Uri.parse(settings.name!).queryParameters["user"] != null) {
        //       var uri = Uri.parse(settings.name!);
        //       var userId = Uri.parse(settings.name!).queryParameters["user"];
        //       var type = Uri.parse(settings.name!).queryParameters["type"];
        //       createDio(errHandler: (err, handler) {
        //         showErrorSnackbar('Not found');
        //       }).get('/users/${userId}/').then((value) {
        //         print(value);
        //         User user = UserState().convertMapToUser(value.data);
        //         if (type == 'event') {
        //           Get.toNamed('/other_profile/passport', arguments: user);
        //         } else {
        //           Get.toNamed('/qr/user', arguments: user);
        //         }
        //       });
        //       return MaterialPageRoute(builder: (context) {
        //         return Container();
        //       });
        //     }
        //   }
        // },
        // routerDelegate: AppRouterDelegate(),
        debugShowCheckedModeBanner: false,
        transitionDuration: Duration.zero,
        defaultTransition: Transition.noTransition,
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
            name: '/article/photos',
            page: () => ArticlePhotosScreen(),
          ),
          GetPage(
            name: '/add_edit_article',
            page: () => AddEditArticleScreen(),
          ),
          GetPage(name: '/chat', page: () => ChatScreen()),
          GetPage(name: '/chat/folder', page: () => FolderScreen()),
          GetPage(name: '/chat/create', page: () => ChatCreateScreen()),
          GetPage(
            name: '/chat/photo',
            page: () => ChatPhotoScreen(),
          ),
          GetPage(
            name: '/members',
            page: () => MembersScreen(),
          ),
          GetPage(name: '/other_profile', page: () => SomeoneProfile()),
          GetPage(
              name: '/other_profile/passport',
              page: () => MyProfileScreen(showPassport: true)),
          GetPage(
            name: '/qr/user',
            page: () => QrUser(),
          ),
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
          GetPage(
              name: '/my_profile/documents/document/watch',
              page: () => DocumentWatchScreen()),
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
            page: () => AddEditEventScreen(),
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
            name: '/videos/watch',
            page: () => VideoWatchScreen(),
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
    );
  }
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

List<Widget> intersperse(Iterable<Widget> list, Widget item) {
  final initialValue = <Widget>[];
  return list.fold(initialValue, (all, el) {
    if (all.isNotEmpty) all.add(item);
    all.add(el);
    return all;
  });
}

List<String>? getCmds() {
  late final String cmd;
  var cmdSuffix = '';

  const plainPath = 'path/subpath';
  const args = 'path/portion/?uid=123&token=abc';
  const emojiArgs =
      '?arr%5b%5d=123&arr%5b%5d=abc&addr=1%20Nowhere%20Rd&addr=Rand%20City%F0%9F%98%82';

  if (kIsWeb) {
    return [
      plainPath,
      args,
      emojiArgs,
      // Cannot create malformed url, since the browser will ensure it is valid
    ];
  }

  if (Platform.isIOS) {
    cmd = '/usr/bin/xcrun simctl openurl booted';
  } else if (Platform.isAndroid) {
    cmd = '\$ANDROID_HOME/platform-tools/adb shell \'am start'
        ' -a android.intent.action.VIEW'
        ' -c android.intent.category.BROWSABLE -d';
    cmdSuffix = "'";
  } else {
    return null;
  }

  // https://orchid-forgery.glitch.me/mobile/redirect/
  return [
    '$cmd "unilinks://host/$plainPath"$cmdSuffix',
    '$cmd "unilinks://example.com/$args"$cmdSuffix',
    '$cmd "unilinks://example.com/$emojiArgs"$cmdSuffix',
    '$cmd "unilinks://@@malformed.invalid.url/path?"$cmdSuffix',
  ];
}

// class AppRouterDelegate extends GetDelegate {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       onPopPage: (route, result) => route.didPop(result),
//       pages: currentConfiguration != null
//           ? [currentConfiguration!.currentPage!]
//           : [GetNavConfig.fromRoute('/bar')!.currentPage!],
//     );
//   }
// }
