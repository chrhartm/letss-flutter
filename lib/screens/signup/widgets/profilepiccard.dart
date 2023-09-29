import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/other/loader.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool processing = false;

  Future loadImage(UserProvider user) async {
    try {
      this.imageRaw = (await _picker.pickImage(source: ImageSource.gallery));
    } catch (e) {
      LoggerService.log(
          "Could not open picture gallery. Please check app permissions in your settings.",
          level: "w");
    }

    if (this.imageRaw != null) {
      String path = "";
      try {
        path = (await crop(imageRaw!.path))!.path;
      } catch (err) {
        path = imageRaw!.path;
      }
      await user.updatePerson(profilePic: [widget.name, File(path)]);
    } else {
    }
    this.setState(() {
      return;
    });
  }

  Future<CroppedFile?> crop(String pathRaw) async {
    return ImageCropper().cropImage(
        sourcePath: pathRaw,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [AndroidUiSettings(
            toolbarTitle: AppLocalizations.of(context)!.profilePicCrop,
            toolbarColor: Theme.of(context).colorScheme.secondary,
            toolbarWidgetColor: Theme.of(context).colorScheme.background,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        )]);
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
                  splashColor: Colors.transparent,
                  onPressed: () {
                    user.deleteProfilePic(widget.name);
                  }))
          : CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      processing = true;
                    });
                    loadImage(user).then((_) {
                      setState(() {
                        processing = false;
                      });
                    }).onError((e, s) {
                      setState(() {
                        processing = false;
                      });
                    });
                  }));
      return Stack(alignment: Alignment.center, children: [
        AspectRatio(
            aspectRatio: 1 / 1,
            child: user.user.person.profilePicByName(widget.name)),
        processing
            ? Positioned(
                child: Align(
                    alignment: Alignment.center,
                    child: Loader(
                        padding: 30,
                        color: Theme.of(context).colorScheme.onBackground)))
            : Positioned(bottom: 5, right: 5, child: button)
      ]);
    });
  }
}
