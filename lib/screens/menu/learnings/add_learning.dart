import 'package:flutter/material.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/bottom_panel.dart';
import 'package:grandmaster/widgets/brand_button.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/input.dart';

class AddLearningScreen extends StatefulWidget {
  AddLearningScreen({Key? key}) : super(key: key);

  @override
  State<AddLearningScreen> createState() => _AddLearningScreenState();
}

class _AddLearningScreenState extends State<AddLearningScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      noPadding: true,
      scrollable: true,
      bottomNavigationBar: BottomPanel(
        withShadow: false,
        child: BrandButton(
          text: 'Опубликовать',
        ),
      ),
      appBar: AppHeader(
        text: 'Создание материала',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
            ),
            Text(
              'Введите название',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 24,
            ),
            Input(
              label: 'Название',
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Введите описание',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 24,
            ),
            Input(
              label: 'Описание',
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Введите ссылку на документ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 24,
            ),
            Input(
              label: 'Ссылка',
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Введите порядковый номер',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              height: 24,
            ),
            Input(
              label: 'Номер (1, 2, 3 и т.п.)',
            )
          ],
        ),
      ),
    );
  }
}
