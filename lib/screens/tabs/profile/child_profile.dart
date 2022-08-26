import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/screens/tabs/chat/chat.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../state/user.dart';
import '../../../utils/bottombar_wrap.dart';
import '../../../widgets/images/brand_icon.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({Key? key}) : super(key: key);

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  late final User user;
  bool isLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoaded = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      createDio().get('/users/${Get.arguments.id}/').then((value) {
        var e = value.data;
        setState(() {
          user = Provider.of<UserState>(context, listen: false)
              .convertMapToUser(e);
          isLoaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded)
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    return Scaffold(
        bottomNavigationBar: BottomBarWrap(
          currentTab: 3,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 32, left: 0, right: 0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 28,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: BrandIcon(
                    icon: 'back_arrow',
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Positioned(
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Container(
                          height: 136,
                          width: 136,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: user.photo == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.black12,
                                    )
                                  : Avatar(user.photo!))),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        user.fullName,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Divider(
                        height: 0,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Info(
                          user: user,
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}

class Info extends StatelessWidget {
  Info({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondaryContainer;
    return ListView(
      shrinkWrap: true,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Дата рождения',
          style: TextStyle(color: color),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          user.birthday != null
              ? DateFormat('d.MM.y').format(user.birthday!)
              : '',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'Номер телефона',
          style: TextStyle(color: color),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "${user.phoneNumber ?? "Нет"}",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: user.phoneNumber != null
                  ? Color(0xFF2674E9)
                  : Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'Страна',
          style: TextStyle(color: color),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          user.country,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'Город',
          style: TextStyle(color: color),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          user.city,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary),
        ),
      ],
    );
  }
}
