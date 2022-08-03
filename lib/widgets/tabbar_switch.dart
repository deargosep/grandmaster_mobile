import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/top_tab.dart';

class TabsSwitch extends StatefulWidget {
  const TabsSwitch(
      {Key? key,
      this.labels,
      this.children,
      this.initialIndex,
      this.controller,
      this.mockupOnly})
      : super(key: key);
  final labels;
  final children;
  final initialIndex;
  final TabController? controller;
  final mockupOnly;
  @override
  State<TabsSwitch> createState() => _TabsSwitchState();
}

class _TabsSwitchState extends State<TabsSwitch> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      if (mounted) setState(() {});
    });
  }

  // @override
  // void dispose() {
  //   widget.controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: TabBar(
          controller: widget.controller,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 0,
          isScrollable: false,
          indicator: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: widget.controller?.index == 0
                  ? BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))
                  : BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
          splashBorderRadius: BorderRadius.all(Radius.circular(10)),
          unselectedLabelColor: Color(0xFF927474),
          labelColor: Colors.white,
          tabs: widget.mockupOnly == true
              ? [
                  TopTab(
                    text: 'Списком',
                  ),
                  TopTab(
                    text: 'На карте',
                  ),
                ]
              : widget.children),
    );
  }
}
