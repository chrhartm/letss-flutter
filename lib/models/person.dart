import 'dart:io';
import 'dart:typed_data';
import 'dart:convert' as convert_lib;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as image_lib;

import 'package:letss_app/backend/personservice.dart';
import 'package:letss_app/models/locationinfo.dart';
import 'package:letss_app/screens/widgets/other/dummyimage.dart';
import 'activitypersondata.dart';
import 'category.dart';
import 'package:letss_app/theme/theme.dart';

class Person {
  String uid;
  String name;
  String? bio;
  String job;
  String? gender;
  String badge;
  int age;
  List<Category>? interests;
  Map<String, dynamic> _profilePicUrls;
  Uint8List? _thumbnailData;
  LocationInfo? location;

  Person(
      {required this.uid,
      required this.name,
      required this.bio,
      required this.age,
      required this.gender,
      required this.job,
      required this.interests,
      required this.badge})
      : _profilePicUrls = const {};

  Person.emptyPerson({String name = "", String job = "", String uid = ""})
      : this.uid = uid,
        this.name = name,
        this.job = job,
        this.age = 0,
        this._profilePicUrls = const {},
        this.badge = "";

  Map<String, dynamic> toJson({bool datestring = false}) => {
        'name': name,
        'bio': bio,
        'age': age,
        'job': job,
        'gender': gender,
        'interests': hasInterests ? interests!.map((e) => e.name).toList() : [],
        'profilePicUrls': _profilePicUrls,
        'thumbnail': _thumbnailData == null ? null : _thumbnailData.toString(),
        'location': location == null ? null : location!.toJson(),
        'badge': badge,
      };

  Person.fromJson({required Map<String, dynamic> json})
      : uid = json['uid'],
        name = json['name'],
        bio = json['bio'],
        gender = json["gender"],
        age = json['age'],
        job = json['job'],
        interests = json["interests"] == null
            ? []
            : List.from(json['interests'])
                .map((e) => Category.fromString(name: e))
                .toList(),
        _profilePicUrls = json['profilePicUrls'] == null
            ? {}
            : _cleanUrls(json['profilePicUrls'] as Map<String, dynamic>),
        _thumbnailData = json['thumbnail'] == null
            ? null
            : Uint8List.fromList(
                convert_lib.json.decode(json['thumbnail']).cast<int>()),
        location = json['location'] == null
            ? null
            : LocationInfo.fromJson(json['location']),
        // Doing check in case it's null
        badge = json['badge'] == null ? "" : json['badge'];

  bool isComplete() {
    if (this.name == "" ||
        this._profilePicUrls.length == 0 ||
        this._thumbnailData == null ||
        this.job == "" ||
        this.age > 200 ||
        this.uid == "") {
      return false;
    }
    return true;
  }

  String get locationString {
    return location == null ? "" : location!.generateLocation();
  }

  String get longLocationString {
    return location == null ? "" : location!.generateLocation(long: true);
  }

  String distanceString(LocationInfo? otherLocation,
      {bool reverse = false}) {
    if (location == null || otherLocation == null) {
      return "";
    }
    String output = reverse
        ? otherLocation.generateLocation(otherLocation: this.location)
        : this.location!.generateLocation(otherLocation: otherLocation);
    return output;
  }

  String get supporterBadge {
    if (badge == "") {
      return "";
    }
    return "\u{00A0}$badge";
  }

  Future deleteProfilePic(String name) async {
    String? key;
    _profilePicUrls.forEach((k, v) {
      if (v["name"] == name) {
        key = k;
      }
    });
    if (key == null) {
      return;
    }
    _profilePicUrls.remove(key!);
    int i;
    // already removed one so don't have to take length-1
    int len = _profilePicUrls.length;
    for (i = int.parse(key!); i < len; i++) {
      _profilePicUrls[i.toString()] = _profilePicUrls[(i + 1).toString()];
    }
    // i was incremented at end of loop already
    // have to write null because firestore update will not delete
    _profilePicUrls[(i).toString()] = null;
    // Profile pic was deleted
    if (key == "0") {
      await _updateThumbnail();
    }
  }

  Future switchPics(int a, int b) async {
    String? keyA;
    String? keyB;
    _profilePicUrls.forEach((k, v) {
      if (k == a.toString()) {
        keyA = k;
      } else if (k == b.toString()) {
        keyB = k;
      }
    });
    if (keyA == null || keyB == null) {
      return;
    }
    Map<String, dynamic> temp = _profilePicUrls[keyA!];
    _profilePicUrls[keyA!] = _profilePicUrls[keyB!];
    _profilePicUrls[keyB!] = temp;
    if (a == 0 || b == 0) {
      await _updateThumbnail();
    }
  }

  Future<bool> updateProfilePic(List<Object> profilePicData) async {
    File profilePic = profilePicData[1] as File;
    String profilePicName = profilePicData[0] as String;
    final image = image_lib.decodeImage(profilePic.readAsBytesSync())!;
    profilePic.deleteSync();
    final imageResized = image_lib.copyResizeCropSquare(image, size: 1080);
    profilePic.writeAsBytesSync(image_lib.encodeJpg(imageResized));
    String url = await PersonService.uploadImage(profilePicName, profilePic);
    bool updated = false;
    bool updateThumbnail = _profilePicUrls.length == 0;
    _profilePicUrls.forEach((k, v) {
      if (v["name"] == profilePicName) {
        _profilePicUrls[k]["url"] = url;
        updated = true;
        if (k == "0") {
          updateThumbnail = true;
        }
      }
    });
    if (!updated) {
      _profilePicUrls[_profilePicUrls.length.toString()] = {
        "name": profilePicName,
        "url": url
      };
    }
    if (updateThumbnail) {
      this._updateThumbnailWithImage(image);
    }

    // returning value so that other function can wait for this to finish
    return true;
  }

  Future _updateThumbnail() async {
    if (_profilePicUrls.length > 0) {
      try {
        // This assumes that CachedNetworkImage uses DefaultCacheManager with url as key
        File picFile = (await DefaultCacheManager()
                .getFileFromCache(_profilePicUrls["0"]["url"]))!
            .file;
        image_lib.Image picImage =
            image_lib.decodeImage(picFile.readAsBytesSync())!;
        _updateThumbnailWithImage(picImage);
      } catch (err) {
        _thumbnailData = null;
      }
    } else {
      _thumbnailData = null;
    }
  }

  void _updateThumbnailWithImage(image_lib.Image image) {
    final imageThumbnail = image_lib.copyResize(image, width: 100);
    this._thumbnailData =
        Uint8List.fromList(image_lib.encodePng(imageThumbnail));
  }

  Widget get thumbnail {
    ImageProvider image;
    if (_thumbnailData != null) {
      image = MemoryImage(_thumbnailData!);
      return CircleAvatar(
          backgroundImage: image,
          backgroundColor: apptheme.colorScheme.primary);
    } else {
      return CircleAvatar(backgroundColor: apptheme.colorScheme.primary);
    }
  }

  Widget get smallThumbnail {
    ImageProvider image;
    if (_thumbnailData != null) {
      image = MemoryImage(_thumbnailData!);
      return CircleAvatar(
          radius: 14,
          backgroundImage: image,
          backgroundColor: apptheme.colorScheme.primary);
    } else {
      return CircleAvatar(
          radius: 14, backgroundColor: apptheme.colorScheme.primary);
    }
  }

  bool get hasBio {
    return bio != null && bio != "";
  }

  bool get hasInterests {
    return interests != null && interests!.length > 0;
  }

  Widget profilePicByUrl(String? url) {
    if (url != null) {
      return CachedNetworkImage(
          imageUrl: url,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Scaffold(),
          errorWidget: (context, url, error) => DummyImage(),
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 0),
          imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover))));
    }
    return DummyImage();
  }

  Widget profilePicByName(String name) {
    String? url;
    _profilePicUrls.forEach((k, v) {
      if (v["name"] == name) {
        url = v["url"];
      }
    });
    return profilePicByUrl(url);
  }

  String profilePicName(int position) {
    return _profilePicUrls[position.toString()]["name"];
  }

  Widget profilePic(int index) {
    String? url;
    if (_profilePicUrls[index.toString()] != null) {
      url = _profilePicUrls[index.toString()]["url"];
    }
    return profilePicByUrl(url);
  }

  int get nProfilePics {
    return _profilePicUrls.length;
  }

  static Map<String, dynamic> _cleanUrls(Map<String, dynamic> urls) {
    urls.removeWhere((key, value) => (value == null));
    return urls;
  }

  void cleanUrls() {
    _profilePicUrls = _cleanUrls(_profilePicUrls);
  }

  ActivityPersonData get activityPersonData {
    return ActivityPersonData(age: age, gender: gender);
  }

  bool get isMe {
    return uid == FirebaseAuth.instance.currentUser!.uid;
  }
}
