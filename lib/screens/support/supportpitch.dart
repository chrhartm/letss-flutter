import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import 'package:letss_app/models/badge.dart';
import 'package:letss_app/screens/support/supportinfo.dart';
import 'package:letss_app/screens/support/supportthanks.dart';
import 'package:letss_app/screens/widgets/other/loader.dart';
import 'package:letss_app/screens/widgets/tiles/textheaderscreen.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/backend/StoreService.dart';

class SupportPitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SupportPitchState();
}

class SupportPitchState extends State<SupportPitch> {
  int _selected = 1;
  String _badge = "";
  late Set<Badge> _badges;
  bool initialized = false;
  late List<ProductDetails> _products;

  @override
  void initState() {
    super.initState();
    StoreService().getBadges().then((badges) {
      if (badges.length > 0) {
        Set<String> productIds = Set.from(badges.map((badge) => badge.storeId));
        return StoreService().getProducts(productIds).then((products) {
          if (products != null) {
            products.sort((a, b) => -a.price.compareTo(b.price));
            setState(() {
              _products = products;
              _badges = badges;
              initialized = true;
              if (_products.length == 1) {
                _selected = 0;
                _badge = badges
                    .firstWhere(
                        (badge) => badge.storeId == _products[_selected].id)
                    .badge;
              }
            });
          }
        });
      }
    });
  }

  List<Widget> _buildSupportOptions(UserProvider user) {
    List<Widget> widgets = [];
    if (!initialized) {
      widgets.add(Loader());
      return widgets;
    }
    if (_products.length == 0) {
      widgets.addAll([
        Text("Currently no support options available",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4),
        const SizedBox(height: 20),
      ]);
    } else {
      _badge = _badges
          .firstWhere((badge) => badge.storeId == _products[_selected].id)
          .badge;
      widgets.addAll([
        Text("Support us and get a badge next to your name",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4),
        const SizedBox(height: 10),
        Divider(thickness: 0),
        ListTile(
            leading: user.user.person.thumbnail,
            title: Text(user.user.person.name + " " + _badge),
            subtitle: Text(
                user.user.person.job + ", " + user.user.person.locationString)),
        Divider(thickness: 0),
      ]);
      for (int i = 0; i < _products.length; i++) {
        bool selected = _selected == i;
        widgets.add(Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: selected
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.background),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: ListTile(
                onTap: () => setState(() {
                      _selected = i;
                    }),
                leading: CircleAvatar(
                  child: Text(
                      _badges
                          .firstWhere(
                              (badge) => badge.storeId == _products[i].id)
                          .badge,
                      style: Theme.of(context).textTheme.headline1),
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                title: Text(_products[i].description),
                subtitle: Text(
                  "${_products[i].currencySymbol}${_products[i].rawPrice.toStringAsFixed(2)} per month",
                ),
                trailing: _badges
                            .firstWhere(
                                (badge) => badge.storeId == _products[i].id)
                            .id ==
                        user.user.subscription.productId
                    ? Icon(Icons.check,
                        color: Theme.of(context).colorScheme.secondary)
                    : null)));
      }
    }
    widgets.addAll([
      const SizedBox(height: 50),
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: "Load existing subscriptions",
                style: new TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    decoration: TextDecoration.underline),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    context.loaderOverlay.show();
                    StoreService().restorePurchases().then((val) {
                      Future.delayed(Duration(seconds: 1)).then((_) {
                        context.loaderOverlay.hide();
                      });
                    });
                  }),
            TextSpan(
              text: " or ",
              style:
                  new TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            TextSpan(
                text: "Manage subscriptions",
                style: new TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    decoration: TextDecoration.underline),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    StoreService.manageSubscriptions();
                  }),
            TextSpan(
              text:
                  "\n\nIf you subscribe to more than one badge, we will show the highest value one. If the wrong badge shows after a change, reload your subscriptions.",
              style:
                  new TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ]))
    ]);
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
            child: Loader(),
          ),
          overlayOpacity: 0.6,
          child: Scaffold(
              body: SafeArea(
                  child: TextHeaderScreen(
                      header: 'Help us pay the bills ❤️',
                      back: true,
                      child: Column(children: [
                        Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  RemoteConfigService.remoteConfig
                                      .getString("supportPitch"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  strutStyle:
                                      StrutStyle(forceStrutHeight: true),
                                ),
                              ),
                              RichText(
                                  text: TextSpan(
                                text: "Continue reading",
                                style: new TextStyle(color: Colors.blue),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    analytics.logEvent(
                                        name: "Support_ReadMore");
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: false,
                                        isDismissible: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        builder: (BuildContext context) {
                                          return SupportInfo();
                                        });
                                  },
                              )),
                              const SizedBox(height: 30),
                              ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: _buildSupportOptions(user),
                              ),
                            ]))),
                        const SizedBox(height: 10),
                        ButtonPrimary(
                            text: "Support",
                            active: initialized && _products.length > 0,
                            onPressed: () {
                              analytics.logEvent(
                                  name: "Support_Purchase_$_badge");
                              StoreService()
                                  .purchase(_products[_selected])
                                  .then((val) {
                                if (!val) {
                                  // Show error
                                  LoggerService.log(
                                      "Could not complete purchase.",
                                      level: "e");
                                } else {
                                  return showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      isDismissible: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      builder: (BuildContext context) {
                                        return FractionallySizedBox(
                                            heightFactor: 0.3,
                                            child: SupportThanks());
                                      });
                                }
                              });
                            })
                      ])))));
    });
  }
}
