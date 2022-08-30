import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grandmaster/state/payments.dart';
import 'package:grandmaster/utils/bottombar_wrap.dart';
import 'package:grandmaster/utils/custom_scaffold.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:grandmaster/widgets/header.dart';
import 'package:grandmaster/widgets/tabbar_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PaymentsState>(context, listen: false).setPayments();
      if (mounted)
        Timer.periodic(Duration(seconds: 20), (timer) {
          Provider.of<PaymentsState>(context, listen: false).setPayments();
        });
    });
    controller = TabController(vsync: this, length: 2);
    controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<PaymentType> payments = Provider.of<PaymentsState>(context).payments;
    bool isLoaded = Provider.of<PaymentsState>(context).isLoaded;
    return DefaultTabController(
      length: 2,
      child: CustomScaffold(
          padding: EdgeInsets.only(top: 24),
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
                    isLoaded
                        ? RefreshIndicator(
                            onRefresh:
                                Provider.of<PaymentsState>(context).setPayments,
                            child: ListView(
                                children: payments
                                    .map(((e) =>
                                        !e.paid ? _Payment(e) : Container()))
                                    .toList()),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    isLoaded
                        ? RefreshIndicator(
                            onRefresh:
                                Provider.of<PaymentsState>(context).setPayments,
                            child: ListView(
                              children: (payments
                                  .map(
                                      (e) => e.paid ? _Payment(e) : Container())
                                  .toList()),
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
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
      return DateTime.now().isAfter(item.must_be_paid_at);
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
                          item.purpose,
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
                                'Оплатить до: ${DateFormat('dd.MM.y').format(item.must_be_paid_at)}',
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: getTextColor()),
                              )
                      ],
                    ),
                    Text(
                      '${item.amount}.00 ₽',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: getTextColor()),
                    )
                  ],
                ),
              ),
              !item.paid
                  ? GestureDetector(
                      onTap: () {
                        createDio()
                            .get('/invoices/pay_bill/${item.id}/')
                            .then((value) {
                          launchUrl(Uri.parse(value.data["confirmation_url"]),
                              mode: LaunchMode.externalApplication);
                          Provider.of<PaymentsState>(context, listen: false)
                              .setPayments();
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 4,
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
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        !item.paid ? Divider() : Container(),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}
