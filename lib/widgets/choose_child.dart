import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grandmaster/state/user.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:provider/provider.dart';

class ChooseChild extends StatelessWidget {
  const ChooseChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserState>(context).user;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: ListView(
        children: [
          SizedBox(
            height: 24,
          ),
          Text(
            'Выберите своего ребенка',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, top: 0, bottom: 20),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: user.children.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Option(
                        noArrow: true,
                        text: user.children[index].fullName,
                        onTap: () {
                          Provider.of<UserState>(context, listen: false)
                              .setChildId(user.children[index].id);
                          Get.back();
                        },
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
