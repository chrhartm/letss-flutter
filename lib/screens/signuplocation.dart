import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../widgets/buttonprimary.dart';
import '../provider/userprovider.dart';
import 'package:location/location.dart';
import 'signuppic.dart';

class SignUpLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          title: 'Where are you? ‍🌍',
          subtitle: 'Please give us permission access your location.',
          child: Locator(),
          back: true,
        ),
      ),
    );
  }
}

class Locator extends StatelessWidget {
  void getLocation(UserProvider user, BuildContext context) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    user.update(
        latitude: _locationData.latitude, longitude: _locationData.longitude);

    Navigator.pushNamed(context, '/signup/pic');
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
                  child: Icon(Icons.location_pin, size: 70))),
          ButtonPrimary(
            onPressed: () {
              getLocation(user, context);
            },
            text: 'Share location',
          ),
        ],
      );
    });
  }
}
