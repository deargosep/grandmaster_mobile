import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/brand_checkbox.dart';

class BrandCheckboxListTile extends StatelessWidget {
  const BrandCheckboxListTile(
      {Key? key,
      required this.value,
      required this.title,
      this.rawTitle,
      required this.onChanged,
      this.onTap,
      this.use_title = false})
      : super(key: key);
  final value;
  final String title;
  final String? rawTitle;
  final onChanged;
  final bool use_title;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          BrandCheckbox(
            checked: value,
            onChanged: () {
              if (use_title) {
                onChanged(title, !value);
              } else {
                onChanged(!value);
              }
            },
          ),
          SizedBox(
            width: 13,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (onTap != null) onTap!();
                if (rawTitle != null) if (rawTitle!.contains('_')) {
                  var id = rawTitle!.split('_')[0];
                  createDio().get('/users/${id}/').then((value) {
                    User user = UserState().convertMapToUser(value.data);
                    Get.toNamed('/other_profile', arguments: user);
                  });
                }
              },
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}
