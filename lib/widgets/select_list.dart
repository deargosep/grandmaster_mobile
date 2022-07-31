import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/brand_select.dart';

class SelectList extends StatelessWidget {
  const SelectList(
      {Key? key,
      required this.onChange,
      required this.value,
      required this.items})
      : super(key: key);
  final onChange;
  final value;
  final Map items;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            onChange(items.values.elementAt(0));
          },
          child: Row(
            children: [
              BrandSelect(
                  onChanged: () {
                    onChange(items.values.elementAt(0));
                  },
                  checked: value == items.values.elementAt(0)),
              SizedBox(
                width: 10,
              ),
              Text(
                items.keys.elementAt(0),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6A7592),
                    fontSize: 14),
              )
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            BrandSelect(
                onChanged: () {
                  onChange(items.values.elementAt(1));
                },
                checked: value == items.values.elementAt(1)),
            SizedBox(
              width: 10,
            ),
            Text(
              items.keys.elementAt(1),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6A7592),
                  fontSize: 14),
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: () {
            onChange(items.values.elementAt(2));
          },
          child: Row(
            children: [
              BrandSelect(
                  onChanged: () {
                    onChange(items.values.elementAt(2));
                  },
                  checked: value == items.values.elementAt(2)),
              SizedBox(
                width: 10,
              ),
              Text(
                items.keys.elementAt(2),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6A7592),
                    fontSize: 14),
              )
            ],
          ),
        ),
      ],
    );
  }
}
