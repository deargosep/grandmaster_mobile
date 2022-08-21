import 'package:flutter/material.dart';
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

import '../../../utils/bottombar_wrap.dart';

class PlacesScheduleScreen extends StatelessWidget {
  const PlacesScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PlaceType> places = Provider.of<PlacesState>(context).places;
    List<OptionType> list = places
        .map((e) => OptionType(e.name, '/schedule/groups', arguments: e))
        .toList();
    return CustomScaffold(
        noTopPadding: true,
        bottomNavigationBar: BottomBarWrap(currentTab: 0),
        appBar: AppHeader(
          text: 'Расписание',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              'Выберите зал',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            SizedBox(
              height: 32,
            ),
            ListOfOptions(
              list: list,
              noArrow: true,
            )
          ],
        ));
  }
}
