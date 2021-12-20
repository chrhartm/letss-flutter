import 'package:flutter/material.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/buttons/mytextbutton.dart';

class SignUpLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "‍🌍",
          title: 'Where are you?',
          subtitle: 'We will only store your area, not your exact location.',
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
        LoggerService.log('Location service is not enabled.', level: "e");
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        LoggerService.log('Please grant permission to access location.', level: "e");
        return;
      }
    }

    _locationData = await location.getLocation();

    user.update(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      String defaultText = "Tap to share location";
      String buttonText = user.user.person.locationString == ""
          ? defaultText
          : user.user.person.locationString;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.location_pin, size: 70)),
                MyTextButton(
                  text: buttonText,
                  highlighted: buttonText == defaultText,
                  onPressed: () {
                    getLocation(user, context);
                  },
                ),
              ])),
          ButtonPrimary(
              onPressed: () {
                if (buttonText != defaultText) {
                  Navigator.pushNamed(context, '/signup/pic');
                }
              },
              text: 'Next',
              active: buttonText != defaultText)
        ],
      );
    });
  }
}
