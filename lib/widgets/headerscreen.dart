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
    return Row(children: [
      GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.navigate_before)),
      const SizedBox(width: 5),
      Expanded(child: this.header)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(children: [
          Align(
              alignment: Alignment.topLeft, child: this._buildHeader(context)),
          const SizedBox(height: 20),
          Expanded(child: this.child),
        ]));
  }
}
