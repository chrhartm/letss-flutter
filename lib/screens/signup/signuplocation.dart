import 'package:flutter/material.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/buttons/mytextbutton.dart';

class SignUpLocation extends StatelessWidget {
  final bool signup;

  SignUpLocation({this.signup = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "‍🌍",
          title: 'Where are you?',
          subtitle: 'We will only store your area, not your exact location.',
          child: Locator(signup: signup,),
          back: true,
        ),
      ),
    );
  }
}

class Locator extends StatefulWidget {
  final bool signup;

  Locator({required this.signup, Key? key}) : super(key: key);

  @override
  LocatorState createState() {
    return LocatorState();
  }
}

class LocatorState extends State<Locator> {
  bool processing = false;

  Future getLocation(UserProvider user, BuildContext context) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        LoggerService.log('Failed to access location.', level: "e");
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      analytics.logEvent(name: "Location_Request_Permission");
      if (_permissionGranted != PermissionStatus.granted) {
        analytics.logEvent(name: "Location_Permission_Denied");
        LoggerService.log('Please grant permission to access location.',
            level: "e");
        return;
      } else {
        analytics.logEvent(name: "Location_Permission_Granted");
      }
    }

    _locationData = await location.getLocation();

    await user.updatePerson(
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
                  text: processing ? "Loading..." : buttonText,
                  highlighted: buttonText == defaultText,
                  onPressed: () {
                    setState(() {
                      analytics.logEvent(name: "Location_Get");
                      processing = true;
                    });

                    getLocation(user, context)
                        .then((val) => setState(() {
                              processing = false;
                            }))
                        .onError((error, stackTrace) {
                      setState(() {
                        processing = false;
                      });
                    });
                  },
                ),
              ])),
          ButtonPrimary(
              onPressed: () {
                if (buttonText != defaultText) {
                  widget.signup?Navigator.pushNamed(context, '/signup/bio'):Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
                }
              },
              text: widget.signup?'Next':'Finish',
              active: buttonText != defaultText && !processing)
        ],
      );
    });
  }
}
