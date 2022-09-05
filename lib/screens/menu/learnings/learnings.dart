import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/learnings.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/brand_card.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../state/user.dart';
import '../../../utils/dio.dart';
import '../../../utils/tablet.dart';

class LearningsScreen extends StatefulWidget {
  const LearningsScreen({Key? key}) : super(key: key);

  @override
  State<LearningsScreen> createState() => _LearningsScreenState();
}

class _LearningsScreenState extends State<LearningsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LearningsState>(context, listen: false).setLearnings();
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    bool isModer() {
      return user.role == 'moderator';
    }

    Orientation currentOrientation = MediaQuery.of(context).orientation;

    List<LearningType> items = Provider.of<LearningsState>(context).learnings;
    bool isLoaded = Provider.of<LearningsState>(context).isLoaded;
    return CustomScaffold(
        noPadding: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Учебные материалы',
          icon: isModer() ? 'plus' : '',
          iconOnTap: isModer()
              ? () {
                  Get.toNamed('/learnings/add');
                }
              : null,
        ),
        body: isLoaded
            ? items.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RefreshIndicator(
                      onRefresh:
                          Provider.of<LearningsState>(context, listen: false)
                              .setLearnings,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      getDeviceType() == 'tablet' ? 2 : 1,
                                  crossAxisSpacing: 24.0,
                                  mainAxisSpacing: 0.0,
                                  childAspectRatio: getDeviceType() == 'tablet'
                                      ? currentOrientation ==
                                              Orientation.portrait
                                          ? 2.8
                                          : 4.4
                                      : 3.4),
                          itemCount: items.length,
                          itemBuilder: (context, index) => Container(
                                margin: EdgeInsets.only(bottom: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    Uri url = Uri.parse(items[index].link);
                                    launchUrl(url,
                                        mode: LaunchMode.externalApplication);
                                  },
                                  child: BrandCard(
                                    items[index],
                                    withPadding: false,
                                    type: 'learning',
                                    () {
                                      createDio().patch(
                                          '/instructions/${items[index].id}/',
                                          data: {"hidden": true});
                                      Provider.of<LearningsState>(context)
                                          .setLearnings();
                                    },
                                    () {
                                      createDio().delete(
                                          '/instructions/${items[index].id}/');
                                      Provider.of<LearningsState>(context)
                                          .setLearnings();
                                    },
                                  ),
                                ),
                              )),
                    ),
                  )
                : Center(
                    child: Text('Нет учебных материалов'),
                  )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class LearningCard extends StatelessWidget {
  const LearningCard(this.item, {Key? key}) : super(key: key);
  final LearningType item;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).inputDecorationTheme.fillColor,
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            item.description,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondaryContainer),
          ),
        ],
      ),
    );
  }
}
