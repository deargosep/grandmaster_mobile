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
      // Provider.of<LearningsState>(context, listen: false).setLearnings();
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    bool isModer() {
      return user.role == 'moderator';
    }

    List<LearningType> items = Provider.of<LearningsState>(context).learnings;

    return CustomScaffold(
        noPadding: true,
        scrollable: true,
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              ...items.map((e) => Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () {
                        Uri url = Uri.parse(e.link);
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      },
                      child: BrandCard(
                        e,
                        withPadding: false,
                        type: 'learning',
                        () {
                          createDio().patch('/instructions/${e.id}/',
                              data: {"hidden": true});
                          Provider.of<LearningsState>(context).setLearnings();
                        },
                        () {
                          createDio().delete('/instructions/${e.id}/');
                          Provider.of<LearningsState>(context).setLearnings();
                        },
                      ),
                    ),
                  )),
              SizedBox(
                height: 16,
              )
            ],
          ),
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
      width: MediaQuery.of(context).size.width,
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
