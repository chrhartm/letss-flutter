import 'package:flutter/material.dart';

class HeaderScreen extends StatelessWidget {
  const HeaderScreen(
      {Key? key, required this.header, required this.child, this.back = false})
      : super(key: key);

  final Widget header;
  final Widget child;
  final bool back;

  Widget _buildHeader(BuildContext context) {
    if (!this.back) {
      return header;
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.maybePop(context);
                  })),
          const SizedBox(height: 8),
          this.header
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 0),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: this._buildHeader(context))),
              const SizedBox(height: 10),
              Expanded(child: this.child),
            ])));
  }
}
