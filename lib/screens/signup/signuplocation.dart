import 'package:flutter/material.dart';
import 'package:letss_app/backend/configservice.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/screens/widgets/other/emojilisttile.dart';
import 'package:letss_app/screens/widgets/other/textdivider.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';
import '../widgets/other/loader.dart';

class SignUpLocation extends StatelessWidget {
  final bool signup;

  SignUpLocation({this.signup = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool? singleScreen = ModalRoute.of(context)!.settings.arguments as bool?;

    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Loader(),
        ),
        overlayOpacity: 0.6,
        child: Scaffold(
          body: SafeArea(
            child: SubTitleHeaderScreen(
              top: "‍🌍",
              title: 'Where are you?',
              subtitle: signup
                  ? 'We will only store your area, not your exact location.'
                  : "To also change the location of your ideas, edit them afterwards.",
              child: Locator(
                signup: signup,
                singleScreen: singleScreen == null ? false : singleScreen,
              ),
              back: true,
            ),
          ),
        ));
  }
}

class Locator extends StatefulWidget {
  final bool signup;
  final bool singleScreen;

  Locator({required this.signup, required this.singleScreen, Key? key})
      : super(key: key);

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
  }

  Widget _buildLocator(UserProvider user) {
    return EmojiListTile(
      emoji: "📍",
      title: "Share location",
      onTap: () async {
        setState(() {
          processing = true;
        });
        context.loaderOverlay.show();
        getLocation(user, context)
            .then((val) => setState(() {
                  processing = false;
                  context.loaderOverlay.hide();
                }))
            .onError((error, stackTrace) {
          setState(() {
            processing = false;
            context.loaderOverlay.hide();
          });
        });
      },
    );
  }

  Widget _buildLocation(BuildContext context, int i) {
    List<Map<String, dynamic>> hubs = ConfigService.config.hubs;
    if (i > hubs.length - 1) {
      return Container();
    }
    return EmojiListTile(
      emoji: hubs[i]["emoji"],
      title: hubs[i]["name"],
      onTap: () {
        setState(() {
          processing = true;
        });
        context.loaderOverlay.show();
        Provider.of<UserProvider>(context, listen: false)
            .updatePerson(latitude: hubs[i]["lat"], longitude: hubs[i]["lng"])
            .then((_) {
          Provider.of<ActivitiesProvider>(context, listen: false)
              .resetAfterLocationChange();
          setState(() {
            processing = false;
            context.loaderOverlay.hide();
          });
        });
      },
    );
  }

  Widget _buildTravel() {
    return EmojiListTile(
        emoji: "🗺️",
        title: "Travel around",
        onTap: () {
          Navigator.pushNamed(context, '/profile/location/travel');
        });
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                const SizedBox(height: 30),
                Text(processing ? "Loading..." : locationText,
                    style: Theme.of(context).textTheme.displaySmall!),
                const SizedBox(height: 30),
                Expanded(
                    child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextDivider(text: "Set a location"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildLocator(user),
                    _buildTravel(),
                    SizedBox(height: 20),
                    TextDivider(text: "Or join a hub close to you"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildLocation(context, 0),
                    _buildLocation(context, 1),
                    _buildLocation(context, 2),
                    _buildLocation(context, 3),
                    _buildLocation(context, 4),
                    _buildLocation(context, 5),
                    _buildLocation(context, 6),
                    _buildLocation(context, 7),
                    _buildLocation(context, 8),
                    _buildLocation(context, 9),
                  ],
                ))
              ])),
          ButtonPrimary(
              onPressed: () {
                if (locationText != defaultText) {
                  if (widget.singleScreen) {
                    Navigator.pop(context);
                  } else {
                    widget.signup
                        ? Navigator.pushNamed(context, '/signup/pic')
                        : Navigator.popUntil(
                            context, (Route<dynamic> route) => route.isFirst);
                  }
                }
              },
              text: widget.signup
                  ? 'Two more steps'
                  : ((widget.singleScreen || !widget.signup)
                      ? "Finish"
                      : 'Next'),
              active: locationText != defaultText && !processing)
        ],
      );
    });
  }
}
