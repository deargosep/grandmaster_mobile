import 'package:flutter/material.dart';

class CustomScaffold extends StatefulWidget {
  CustomScaffold(
      {Key? key,
      required Widget this.body,
      bool? this.scrollable,
      this.noPadding = true,
      this.noHorPadding,
      this.noVerPadding,
      this.noBottomPadding,
      this.noTopPadding,
      this.onlyTopPadding,
      EdgeInsets? this.padding,
      this.bottomNavigationBar,
      this.appBar})
      : super(key: key);
  final body;
  bool? scrollable = false;
  bool? noPadding = false;
  bool? noHorPadding = false;
  bool? noVerPadding = false;
  bool? noBottomPadding = false;
  bool? noTopPadding = false;
  bool? onlyTopPadding = false;
  EdgeInsets? padding = EdgeInsets.zero;
  final bottomNavigationBar;
  final appBar;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SharedPreferences.getInstance().then((value) {
    //   if (value.getString('access') != null &&
    //       Provider.of<UserState>(context, listen: false).user.role == 'guest' &&
    //       Get.currentRoute != '/') {
    //     Get.offAllNamed('/');
    //   } else {}
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scrollable == true) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: widget.appBar,
          bottomNavigationBar: widget.bottomNavigationBar,
          body: LayoutBuilder(builder: (context, constraint) {
            return Center(
              child: widget.noPadding == true
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: widget.body,
                      ),
                    )
                  : Padding(
                      padding: widget.onlyTopPadding == true
                          ? EdgeInsets.only(
                              top: 32 + MediaQuery.of(context).viewInsets.top)
                          : widget.padding ??
                              EdgeInsets.fromLTRB(
                                  widget.noHorPadding == true ? 0 : 20,
                                  widget.noVerPadding == true
                                      ? 0
                                      : widget.noTopPadding == true
                                          ? 0
                                          : 32 +
                                              MediaQuery.of(context)
                                                  .viewInsets
                                                  .top,
                                  20,
                                  widget.noVerPadding == true
                                      ? 0
                                      : widget.noBottomPadding == true
                                          ? 0
                                          : 20),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height - 60,
                            child: widget.body,
                          ),
                        ),
                      )),
            );
          }),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: widget.appBar,
        bottomNavigationBar: widget.bottomNavigationBar,
        body: Center(
            child: widget.noPadding == true
                ? widget.body
                : Padding(
                    padding: widget.onlyTopPadding == true
                        ? EdgeInsets.only(
                            top: 40 + MediaQuery.of(context).viewInsets.top)
                        : widget.padding ??
                            EdgeInsets.fromLTRB(
                                widget.noHorPadding == true ? 0 : 20,
                                widget.noVerPadding == true
                                    ? 0
                                    : widget.noTopPadding == true
                                        ? 0
                                        : 32 +
                                            MediaQuery.of(context)
                                                .viewInsets
                                                .top,
                                widget.noHorPadding == true ? 0 : 20,
                                widget.noVerPadding == true
                                    ? 0
                                    : widget.noBottomPadding == true
                                        ? 0
                                        : 20),
                    child: widget.body)),
      ),
    );
  }
}
