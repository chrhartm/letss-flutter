import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../widgets/button1.dart';
import '../provider/userprovider.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          title: 'Picture time 🤳',
          subtitle: 'A smile leads to more matches. Say other apps.',
          child: ProfilePicSelector(),
          back: true,
        ),
      ),
    );
  }
}

class ProfilePicSelector extends StatefulWidget {
  const ProfilePicSelector({Key? key}) : super(key: key);

  @override
  ProfilePicSelectorState createState() {
    return ProfilePicSelectorState();
  }
}

class ProfilePicSelectorState extends State<ProfilePicSelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.portrait, size: 70))),
          Button1(
            onPressed: () {
              return;
            },
            text: 'Next',
          ),
        ],
      );
    });
  }
}
