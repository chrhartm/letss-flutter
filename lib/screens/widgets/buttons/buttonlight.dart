import 'package:flutter/material.dart';

class ButtonLight extends StatelessWidget {
  const ButtonLight(
      {Key? key,
      required this.text,
      this.onPressed,
      required this.icon,
      this.active = true})
      : super(key: key);

  final String text;
  final IconData icon;
  final void Function()? onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(children: [
          Expanded(
              child: TextButton(
                  onPressed: this.active ? this.onPressed : null,
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(this.icon)),
                      Flexible(
                          child: Text(
                        this.text,
                        maxLines: 3,
                      )),
                    ],
                  ),
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.headline3,
                    foregroundColor: Theme.of(context).colorScheme.onBackground,
                    minimumSize: Size(double.infinity, 35),
                    alignment: Alignment.centerLeft,
                  ))),
          IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              splashColor: Colors.transparent,
              onPressed: this.onPressed,
              icon: Icon(Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.secondary))
        ]));
  }
}
