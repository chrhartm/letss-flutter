import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Letss",
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Center(
                heightFactor: 10,
                // Show logo instead moving up and down
                child: Text('Loading'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
