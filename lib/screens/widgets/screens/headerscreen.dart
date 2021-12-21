import 'package:flutter/material.dart';

class HeaderScreen extends StatelessWidget {
  const HeaderScreen(
      {Key? key, required this.header, required this.child, this.back: false})
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
              child: GestureDetector(
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  child: Container(child: Icon(Icons.arrow_back)))),
          const SizedBox(height: 8),
          this.header
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(children: [
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: this._buildHeader(context))),
          const SizedBox(height: 10),
          Expanded(child: this.child),
        ]));
  }
}
