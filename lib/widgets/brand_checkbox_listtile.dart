import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/brand_checkbox.dart';

class BrandCheckboxListTile extends StatelessWidget {
  const BrandCheckboxListTile(
      {Key? key,
      required this.value,
      required this.title,
      required this.onChanged,
      this.use_title = false})
      : super(key: key);
  final value;
  final title;
  final onChanged;
  final bool use_title;
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
          Container(
            width: 263,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
