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
  final List items;
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((e) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  onChange(e);
                },
                child: Row(
                  children: [
                    BrandSelect(
                        onChanged: () {
                          onChange(e);
                        },
                        checked: value == e),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      e.contains('_') ? e.split('_')[1] : e,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          );
        }).toList());
  }
}
