import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final int? count;
  const Counter({
    super.key,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Text(
        count != null ? count.toString() : "",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
