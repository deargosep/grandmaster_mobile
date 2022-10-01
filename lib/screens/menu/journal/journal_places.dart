import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/places.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/list_of_options.dart';
import 'package:provider/provider.dart';

class PlacesJournalScreen extends StatefulWidget {
  const PlacesJournalScreen({Key? key}) : super(key: key);

  @override
  State<PlacesJournalScreen> createState() => _PlacesJournalScreenState();
}

class _PlacesJournalScreenState extends State<PlacesJournalScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PlacesState>(context, listen: false)
          .setPlaces(url: '/gyms/trainers/');
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoaded = Provider.of<PlacesState>(context).isLoaded;
    List<PlaceType> places = Provider.of<PlacesState>(context).places;
    List<OptionType> list = places
        .map((e) => OptionType(e.name, '/journal/groups', arguments: e.id))
        .toList();
    return CustomScaffold(
        noTopPadding: true,
        noPadding: false,
        bottomNavigationBar: places.isNotEmpty
            ? BottomPanel(
                withShadow: false,
                child: BrandButton(
                  text: 'Сформировать отчет',
                  onPressed: () {
                    Get.toNamed('/journal/log');
                  },
                ),
              )
            : null,
        appBar: AppHeader(
          text: 'Журнал посещений',
        ),
        body: isLoaded
            ? list.isNotEmpty
                ? ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        list.isNotEmpty ? 'Выберите зал' : '',
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
                  )
                : Center(
                    child: Text('Нет залов'),
                  )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
