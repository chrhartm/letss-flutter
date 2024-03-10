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

  SignUpLocation({this.signup = true, Key? key}) : super(key: key);

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
        child: Locator(
          signup: signup,
          singleScreen: singleScreen == null ? false : singleScreen,
        ),
        back: true,
      ),
    );
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
        LoggerService.log('Failed to access location.', level: "w");
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        LoggerService.log(
            AppLocalizations.of(context)!.signupLocationNoPermissions,
            level: "e");
        return;
      } else {}
    }

    _locationData = await location.getLocation();
    LocationInfo? locationInfo = await LocationService.getLocationFromLatLng(
        _locationData.latitude!, _locationData.longitude!);

    await user.updatePerson(location: locationInfo).then((_) =>
        Provider.of<ActivitiesProvider>(context, listen: false)
            .resetAfterLocationChange());
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

        LocationService.getLocationFromLatLng(hubs[i]["lat"], hubs[i]["lng"])
            .then((loc) {
          Provider.of<UserProvider>(context, listen: false)
              .updatePerson(location: loc)
              .then((_) {
            Provider.of<ActivitiesProvider>(context, listen: false)
                .resetAfterLocationChange();
            setState(() {
              processing = false;
              context.loaderOverlay.hide();
            });
          });
        });
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 30),
          Align(
              alignment: Alignment.center,
              child: Text(
                processing
                    ? AppLocalizations.of(context)!.loading
                    : locationText,
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
          SizedBox(height: 20),
          TextDivider(
              text: AppLocalizations.of(context)!.signupLocationJoinHub),
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
          Flexible(
              child: ButtonPrimary(
                  onPressed: () {
                    if (locationText != defaultText) {
                      if (widget.singleScreen) {
                        Navigator.pop(context);
                      } else {
                        if (widget.signup) {
                          Navigator.pushNamed(context, '/signup/interests');
                        } else {
                          if (user.user.person.hasBio) {
                            if (user.user.person.hasInterests) {
                              Navigator.popUntil(context,
                                  (Route<dynamic> route) => route.isFirst);
                            } else {
                              Navigator.pushNamed(
                                  context, '/profile/interests');
                            }
                          } else {
                            Navigator.pushNamed(context, '/profile/bio');
                          }
                        }
                      }
                    }
                  },
                  text: widget.signup
                      ? AppLocalizations.of(context)!.signupLocationNextSignup
                      : ((widget.singleScreen ||
                              (!widget.signup &&
                                  user.user.person.hasBio &&
                                  user.user.person.hasInterests))
                          ? AppLocalizations.of(context)!
                              .signupLocationNextProfileFinish
                          : AppLocalizations.of(context)!
                              .signupLocationNextProfileNext),
                  active: locationText != defaultText && !processing))
        ],
      );
    });
  }
}
