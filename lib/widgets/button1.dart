import 'package:flutter/material.dart';

class Button1 extends StatelessWidget {
  const Button1({Key? key, required this.text, this.onPressed})
      : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
          onPressed: this.onPressed,
          child: Text(this.text),
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).accentColor,
              textStyle: Theme.of(context).textTheme.button,
              minimumSize: Size(double.infinity, 35)),
        ));
  }
}
