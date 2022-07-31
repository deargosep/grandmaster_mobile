import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  CustomScaffold(
      {Key? key,
      required Widget this.body,
      bool? this.scrollable,
      bool? this.noPadding,
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
  Widget build(BuildContext context) {
    if (scrollable == true) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: appBar,
          bottomNavigationBar: bottomNavigationBar,
          body: LayoutBuilder(builder: (context, constraint) {
            return Center(
              child: noPadding == true
                  ? SingleChildScrollView(
                      child: body,
                    )
                  : Padding(
                      padding: onlyTopPadding == true
                          ? EdgeInsets.only(
                              top: 32 + MediaQuery.of(context).viewInsets.top)
                          : padding ??
                              EdgeInsets.fromLTRB(
                                  noHorPadding == true ? 0 : 20,
                                  noVerPadding == true
                                      ? 0
                                      : noTopPadding == true
                                          ? 0
                                          : 32 +
                                              MediaQuery.of(context)
                                                  .viewInsets
                                                  .top,
                                  20,
                                  noVerPadding == true
                                      ? 0
                                      : noBottomPadding == true
                                          ? 0
                                          : 20),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height - 60,
                            child: body,
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
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        body: Center(
            child: noPadding == true
                ? body
                : Padding(
                    padding: onlyTopPadding == true
                        ? EdgeInsets.only(
                            top: 40 + MediaQuery.of(context).viewInsets.top)
                        : padding ??
                            EdgeInsets.fromLTRB(
                                noHorPadding == true ? 0 : 20,
                                noVerPadding == true
                                    ? 0
                                    : noTopPadding == true
                                        ? 0
                                        : 32 +
                                            MediaQuery.of(context)
                                                .viewInsets
                                                .top,
                                noHorPadding == true ? 0 : 20,
                                noVerPadding == true
                                    ? 0
                                    : noBottomPadding == true
                                        ? 0
                                        : 20),
                    child: body)),
      ),
    );
  }
}
