import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';

class MembersScreen extends StatelessWidget {
  MembersScreen({Key? key}) : super(key: key);
  final item = Get.arguments;
  @override
  Widget build(BuildContext context) {
    if (item == null) return Scaffold();
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(
          0, 38 + MediaQuery.of(context).viewInsets.top, 0, 0),
      child: Column(
        children: [
          Header(
            text: 'Список участников чата',
          ),
          SizedBox(
            height: 32,
          ),
          Divider(
            height: 0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                itemCount: item["members"].length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/other_profile',
                          arguments: item["members"][index]["username"]);
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // TODO: image (backend)
                              Row(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    child: CircleAvatar(),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    item["members"][index]["username"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer),
                                  ),
                                ],
                              ),
                              Builder(builder: (context) {
                                if (item["isOwner"] != null && !item["isOwner"])
                                  return Container();
                                return Row(
                                  children: [
                                    BrandIcon(
                                      height: 16,
                                      width: 16,
                                      icon: 'decline',
                                      color: Color(0xFF4F3333),
                                    )
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}
