import 'package:flutter/material.dart';
import 'package:letss_app/backend/configservice.dart';
import 'package:letss_app/backend/locationservice.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/models/locationinfo.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/other/emojilisttile.dart';
import 'package:letss_app/screens/widgets/other/textdivider.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpLocation extends StatelessWidget {
  final bool signup;

  const SignUpLocation({this.signup = true, super.key});

  @override
  Widget build(BuildContext context) {
    bool? singleScreen = ModalRoute.of(context)!.settings.arguments as bool?;

    return MyScaffold(
      body: HeaderScreen(
        top: "‍🌍",
        title: AppLocalizations.of(context)!.signupLocationTitle,
        subtitle: signup
            ? AppLocalizations.of(context)!.signupLocationSubtitleSignup
            : AppLocalizations.of(context)!.signupLocationSubtitleProfile,
        back: true,
        child: Locator(
          signup: signup,
          singleScreen: singleScreen ?? false,
        ),
      ),
    );
  }
}

class Locator extends StatefulWidget {
  final bool signup;
  final bool singleScreen;

  const Locator({required this.signup, required this.singleScreen, super.key});
  @override
  LocatorState createState() {
    return LocatorState();
  }
}

class LocatorState extends State<Locator> {
  bool processing = false;

  Future getLocation(UserProvider user, BuildContext context) async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        LoggerService.log('Failed to access location.', level: "w");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        if (context.mounted) {
          LoggerService.log(
              AppLocalizations.of(context)!.signupLocationNoPermissions,
              level: "e");
        }
        return;
      } else {}
    }

    locationData = await location.getLocation();
    LocationInfo? locationInfo = await LocationService.getLocationFromLatLng(
        locationData.latitude!, locationData.longitude!);
    if (context.mounted) {
      await user.updatePerson(location: locationInfo).then((_) =>
          context.mounted
              ? Provider.of<ActivitiesProvider>(context, listen: false)
                  .resetAfterLocationChange()
              : null);
    }
  }

  Widget _buildLocator(UserProvider user) {
    return EmojiListTile(
      emoji: "📍",
      title: AppLocalizations.of(context)!.signupLocationShare,
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

  Widget _buildHub(BuildContext context, Map<String, dynamic> hub) {
    return EmojiListTile(
      emoji: hub["emoji"],
      title: hub["name"],
      onTap: () {
        double lat = hub["lat"] + 0.0;
        double lng = hub["lng"] + 0.0;

        setState(() {
          processing = true;
        });
        context.loaderOverlay.show();

        Future<void> updatePerson(LocationInfo loc) {
          return Provider.of<UserProvider>(context, listen: false)
              .updatePerson(location: loc)
              .then((_) {
            if (context.mounted) {
              Provider.of<ActivitiesProvider>(context, listen: false)
                  .resetAfterLocationChange();
            }
            setState(() {
              processing = false;
              context.loaderOverlay.hide();
            });
          });
        }

        if (lat == 0.0 && lng == 0.0) {
          LocationInfo loc = LocationInfo.fromVirtual(name: hub["name"]);
          updatePerson(loc);
        } else {
          LocationService.getLocationFromLatLng(lat, lng).then((loc) {
            if (loc == null) {
              LoggerService.log("Failed to get location from lat/lng",
                  level: "e");
              return;
            }
            updatePerson(loc);
          });
        }
      },
    );
  }

  Widget _buildTravel() {
    return EmojiListTile(
        emoji: "🗺️",
        title: AppLocalizations.of(context)!.signupLocationTravel,
        onTap: () {
          Navigator.pushNamed(context, '/profile/location/travel');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      String defaultText = AppLocalizations.of(context)!.signupLocationHint;
      String locationText = user.user.person.locationString == ""
          ? defaultText
          : user.user.person.longLocationString;

      List<Widget> widgets = [
        const SizedBox(height: 30),
        Align(
            alignment: Alignment.center,
            child: Text(
              processing ? AppLocalizations.of(context)!.loading : locationText,
              style: Theme.of(context).textTheme.displaySmall!,
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 30),
        TextDivider(
            text: AppLocalizations.of(context)!.signupLocationSetLocation),
        SizedBox(
          height: 10,
        ),
        _buildLocator(user),
        _buildTravel(),
      ];

      List<Map<String, dynamic>> hubs = ConfigService.config.hubs;
      if (hubs.isNotEmpty) {
        widgets.add(SizedBox(height: 20));
        widgets.add(TextDivider(
            text: AppLocalizations.of(context)!.signupLocationJoinHub));
        widgets.add(SizedBox(
          height: 10,
        ));
      }
      // hubs.add({"emoji": "💡", "name": "EAGx Utrecht", "lat": 0.0, "lng": 0.0});
      for (var hub in hubs) {
        widgets.add(_buildHub(context, hub));
      }

      Widget button = ButtonPrimary(
          onPressed: () {
            if (locationText != defaultText) {
              if (widget.singleScreen) {
                Navigator.pop(context);
              } else {
                if (widget.signup) {
                  Navigator.pushNamed(context, '/signup/interests');
                } else {
                  Navigator.popUntil(
                      context, (Route<dynamic> route) => route.isFirst);
                }
              }
            }
          },
          text: widget.signup
              ? AppLocalizations.of(context)!.signupLocationNextSignup
              : ((widget.singleScreen || (!widget.signup))
                  ? AppLocalizations.of(context)!
                      .signupLocationNextProfileFinish
                  : AppLocalizations.of(context)!
                      .signupLocationNextProfileNext),
          active: locationText != defaultText && !processing);

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [Expanded(child: ListView(children: widgets)), button]);
    });
  }
}
