import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePicCard extends StatefulWidget {
  const ProfilePicCard({required this.name, required this.empty, Key? key})
      : super(key: key);

  final String name;
  final bool empty;

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
      user.update(profilePic: [widget.name, File(path)]);
    }
    this.setState(() {
      return;
    });
  }

  Future<File?> crop(String pathRaw) async {
    return await ImageCropper.cropImage(
        sourcePath: pathRaw,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Theme.of(context).colorScheme.secondary,
            toolbarWidgetColor: Theme.of(context).colorScheme.background,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      Widget button = !widget.empty
          ? CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onPressed: () {
                    user.deleteProfilePic(widget.name);
                  }))
          : CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
              child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onPressed: () {
                    loadImage(user);
                  }));
      return Stack(children: [
        AspectRatio(
            aspectRatio: 1 / 1,
            child: user.user.person.profilePicByName(widget.name)),
        Positioned(bottom: 5, right: 5, child: button)
      ]);
    });
  }
}
