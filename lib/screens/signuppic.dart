import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/subtitleheaderscreen.dart';
import '../widgets/buttonprimary.dart';
import '../provider/userprovider.dart';

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
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  void loadImage(UserProvider user) async {
    this.image = await _picker.pickImage(source: ImageSource.gallery);
    if (this.image != null) {
      user.update(profilePic: File(this.image!.path));
    }
    this.setState(() {
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                      onTap: () {
                        loadImage(user);
                      },
                      child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: user.user.person.profilePic)))),
          ButtonPrimary(
            onPressed: () {
              Navigator.pushNamed(context, '/signup/interests');            },
            text: 'Next',
            active: user.user.person.profilePicURL != "",
          ),
        ],
      );
    });
  }
}
