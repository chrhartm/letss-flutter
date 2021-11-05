import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePicCard extends StatefulWidget {
  const ProfilePicCard({Key? key}) : super(key: key);

  @override
  ProfilePicCardState createState() {
    return ProfilePicCardState();
  }
}

class ProfilePicCardState extends State<ProfilePicCard> {
  final ImagePicker _picker = ImagePicker();
  XFile? imageRaw;

  void loadImage(UserProvider user) async {
    this.imageRaw = await _picker.pickImage(source: ImageSource.gallery);
    if (this.imageRaw != null) {
      String path = "";
      try {
        path = (await crop(imageRaw!.path))!.path;
      } catch (err) {
        path = imageRaw!.path;
      }
      user.update(profilePic: File(path));
    }
    this.setState(() {
      return;
    });
  }

  Future<File?> crop(String pathRaw) async {
    return await ImageCropper.cropImage(
        sourcePath: pathRaw,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Theme.of(context).colorScheme.background,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return GestureDetector(
          onTap: () {
            loadImage(user);
          },
          child: AspectRatio(
              aspectRatio: 1 / 1, child: user.user.person.profilePic));
    });
  }
}
