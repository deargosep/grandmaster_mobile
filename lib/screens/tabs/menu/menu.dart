import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/brand_option.dart';
import 'package:grandmaster/widgets/header.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              text: 'Меню пользователя',
              withBack: false,
              withPadding: false,
            ),
            SizedBox(
              height: 32,
            ),
            _ListOfOptions()
          ],
        ),
      ),
    );
  }
}

class _ListOfOptions extends StatelessWidget {
  const _ListOfOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Option(text: 'Мероприятия'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'Видео'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'Учебные материалы'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'Залы'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'Оплата'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'QR коды'),
        SizedBox(
          height: 16,
        ),
        Option(text: 'О клубе'),
      ],
    );
  }
}
