import 'package:flutter/material.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';

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
          child: Locator(
            signup: signup,
          ),
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
      if (_permissionGranted != PermissionStatus.granted) {
        LoggerService.log('Please grant permission to access location.',
            level: "e");
        return;
      } else {}
    }

    _locationData = await location.getLocation();

    await user
        .updatePerson(
            latitude: _locationData.latitude,
            longitude: _locationData.longitude)
        .then((_) => Provider.of<ActivitiesProvider>(context, listen: false)
            .resetAfterLocationChange());
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      String defaultText = "Tap icons to set location";
      String locationText = user.user.person.locationString == ""
          ? defaultText
          : user.user.person.locationString;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                              iconSize: 50,
                              icon: Icon(
                                Icons.location_pin,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              onPressed: () async {
                                setState(() {
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
                            Text("Share location",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground))
                          ]),
                      const SizedBox(width: 20),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                                iconSize: 50,
                                icon: Icon(
                                  Icons.public,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/profile/location/travel');
                                }),
                            Text("Travel around",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground))
                          ]),
                    ]),
                const SizedBox(height: 30),
                Text(processing ? "Loading..." : locationText,
                    style: Theme.of(context).textTheme.displayMedium!),
              ])),
          ButtonPrimary(
              onPressed: () {
                if (locationText != defaultText) {
                  widget.signup
                      ? Navigator.pushNamed(context, '/signup/bio')
                      : Navigator.popUntil(
                          context, (Route<dynamic> route) => route.isFirst);
                }
              },
              text: widget.signup ? 'Next' : 'Finish',
              active: locationText != defaultText && !processing)
        ],
      );
    });
  }
}
