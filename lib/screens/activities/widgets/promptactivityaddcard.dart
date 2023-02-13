import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/myactivitiesprovider.dart';
import '../../widgets/buttons/buttonprimary.dart';

class PromptActivityAddCard extends StatefulWidget {
  PromptActivityAddCard({
    required Function this.onSkip,
    Key? key,
  }) : super(key: key);

  final Function onSkip;

  @override
  PromptActivityAddCardState createState() => PromptActivityAddCardState();
}

class PromptActivityAddCardState extends State<PromptActivityAddCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInToLinear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _animation,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("🧐", style: Theme.of(context).textTheme.displayLarge),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Not finding what you're looking for?",
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: ButtonPrimary(
                  text: "Add your own idea",
                  active: true,
                  padding: 0,
                  onPressed: () {
                    Provider.of<MyActivitiesProvider>(context, listen: false)
                        .addNewActivity(context);
                  }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: ButtonPrimary(
                  text: "Browse our ideas",
                  secondary: true,
                  padding: 0,
                  active: true,
                  onPressed: () {
                    Navigator.pushNamed(context, "/myactivities/templates");
                  }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: ButtonPrimary(
                  text: "Keep looking",
                  secondary: true,
                  padding: 0,
                  active: true,
                  onPressed: () {
                    _controller.forward().whenComplete(() => widget.onSkip());
                  }),
            ),
          ],
        )));
  }
}
