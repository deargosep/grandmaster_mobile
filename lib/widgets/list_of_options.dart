import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'brand_option.dart';

class ListOfOptions extends StatelessWidget {
  const ListOfOptions({Key? key, required this.list, this.noArrow = false})
      : super(key: key);
  final List<OptionType> list;
  final bool noArrow;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list
          .map((e) => Column(
                children: [
                  Option(
                    text: e.name,
                    type: e.type,
                    noArrow: noArrow,
                    mark: e.mark,
                    red: e.red,
                    onTap: () {
                      Get.toNamed(e.screen, arguments: e.arguments);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ))
          .toList(),
    );
  }
}

class OptionType {
  final String name;
  final String screen;
  final String? type;
  final bool? mark;
  final bool red;
  final arguments;
  OptionType(this.name, this.screen,
      {this.arguments, this.type = 'secondary', this.mark, this.red = false});
}
