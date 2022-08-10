import 'package:flutter/material.dart';
import 'package:grandmaster/state/payments.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/tabbar_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../widgets/top_tab.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
    controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<PaymentType> payments = Provider.of<PaymentsState>(context).payments;
    return DefaultTabController(
      length: 2,
      child: CustomScaffold(
          padding: EdgeInsets.only(top: 24),
          scrollable: true,
          bottomNavigationBar: BottomBarWrap(currentTab: 0),
          appBar: AppHeader(
            text: 'Оплата',
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TabsSwitch(
                  controller: controller,
                  children: [
                    TopTab(
                      text: 'Текущие счета',
                    ),
                    TopTab(
                      text: 'История оплат',
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Expanded(
                child: TabBarView(
                  controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                        children: payments
                            .map(((e) => !e.paid ? _Payment(e) : Container()))
                            .toList()),
                    Column(
                      children: (payments
                          .map((e) => e.paid ? _Payment(e) : Container())
                          .toList()),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class _Payment extends StatelessWidget {
  const _Payment(this.item, {Key? key}) : super(key: key);
  final PaymentType item;

  @override
  Widget build(BuildContext context) {
    bool isOverTime() {
      return DateTime.now().isAfter(item.paymentEnd);
    }

    Color getColor() {
      switch (item.paid) {
        case true:
          return Color(0xFFEBFFE8);
        case false:
          return Color(0xFFFFECEC);
        default:
          return Colors.black;
      }
    }

    Color getTextColor() {
      if (item.paid) return Theme.of(context).colorScheme.secondary;
      switch (isOverTime()) {
        case true:
          return Color(0xFFFF5B5B);
        case false:
          return Theme.of(context).colorScheme.secondary;
        default:
          return Colors.black;
      }
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          // height: !paid ? 79 + 95 : 95,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: isOverTime() ? 111 : 95,
                decoration: BoxDecoration(
                    color: getColor(),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: getTextColor()),
                        ),
                        isOverTime() && !item.paid
                            ? Container(
                                width: 204,
                                child: Text(
                                  'Статус спортсмена изменится после погашения счета',
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: getTextColor()),
                                ),
                              )
                            : Text(
                                'Оплатить до: ${DateFormat('d.MM.y').format(item.paymentEnd)}',
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: getTextColor()),
                              )
                      ],
                    ),
                    Text(
                      '${item.price} ₽',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: getTextColor()),
                    )
                  ],
                ),
              ),
              !item.paid
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 43,
                          decoration: BoxDecoration(
                              color: getColor(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            'Оплатить',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: getTextColor()),
                          )),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        Divider(),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}
