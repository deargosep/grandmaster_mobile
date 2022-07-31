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
    return Row(
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
        Text(
          title,
          style:
              TextStyle(color: Color(0xFF6A7592), fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
