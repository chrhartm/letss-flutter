import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:in_app_purchase/in_app_purchase.dart";
import 'package:letss_app/backend/userservice.dart';
import 'package:letss_app/models/badge.dart';
import 'package:letss_app/models/subscription.dart';
import 'package:url_launcher/url_launcher.dart';
import "loggerservice.dart";
import 'dart:io' show Platform;

class StoreService {
  static final StoreService _store = StoreService._internalConstructor();

  late StreamSubscription<List<PurchaseDetails>> _subscription;
  Set<Badge> _badges = {};

  factory StoreService() {
    return _store;
  }

  StoreService._internalConstructor();

  void dispose() {
    _subscription.cancel();
  }

  void init() {
    if (FirebaseAuth.instance.currentUser != null) {
      getBadges();
    }

    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    }) as StreamSubscription<List<PurchaseDetails>>;
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        LoggerService.log("Pending: " + purchaseDetails.productID);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        LoggerService.log(
            "Error processing purchase." + purchaseDetails.error.toString(),
            level: "d");
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          LoggerService.log("Purchased ${purchaseDetails.productID}");

          Set<Badge> badges = await getBadges();
          Badge badge = badges.firstWhere(
            (badge) => badge.storeId == purchaseDetails.productID,
          );

          // DateTime.now might be inaccurate if restoring but unlikely
          UserService.updateSubscription(
                  Subscription(productId: badge.id, timestamp: DateTime.now()))
              .then((val) {
            if (val) {
              if (purchaseDetails.pendingCompletePurchase) {
                return InAppPurchase.instance.completePurchase(purchaseDetails);
              }
            } else {
              LoggerService.log(
                  "Failed to complete purchase for ${purchaseDetails.productID}",
                  level: "e");
            }
          });
        } else {
          LoggerService.log(
            "Failed to verify purchase for ${purchaseDetails.productID}",
          );
        }
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        // This happens when the user cancels during purchasing flow
        LoggerService.log("Canceled ${purchaseDetails.productID}");
        // check if the cancelled purchase is the one that's currently active
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    bool valid = false;
    Set<Badge> badges = await getBadges();
    Subscription subscription = await UserService.getSubscriptionDetails();
    Badge userBadge = badges.firstWhere(
      (badge) => badge.id == subscription.productId,
    );
    Badge purchasedBadge = badges.firstWhere(
      (badge) => badge.storeId == purchase.productID,
    );

    if (purchasedBadge.value > userBadge.value) {
      valid = true;
    }

    // if return false (because other badge higher prio), confirm
    if (!valid) {
      await InAppPurchase.instance.completePurchase(purchase);
    }

    return valid;
  }

  static Future cancelSubscription() async {
    await UserService.updateSubscription(Subscription.emptySubscription());
  }

  Future<List<ProductDetails>?> getProducts(Set<String> _kIds) async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      LoggerService.log("Store is not available", level: "e");
      return null;
    } else {
      // Ugly but play store fails all products if one doesn't exist
      List<ProductDetails> products = [];
      for (String id in _kIds) {
        final ProductDetailsResponse response =
            await InAppPurchase.instance.queryProductDetails(
          [id].toSet(),
        );
        if (response.notFoundIDs.isNotEmpty &&
            response.notFoundIDs.length > 0) {
          LoggerService.log("Product not found: ${response.notFoundIDs}");
        } else {
          products.add(response.productDetails.first);
        }
      }
      return products;
    }
  }

  Future<bool> purchase(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    return InAppPurchase.instance
        .buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<Set<Badge>> getBadges() async {
    if (_badges.length == 0) {
      await FirebaseFirestore.instance
          .collection("badges")
          .get()
          .then((snapshot) {
        Set<Badge> badges = Set();
        snapshot.docs.forEach((doc) {
          LoggerService.log(doc.data().toString());
          badges.add(Badge.fromJson(json: doc.data(), uid: doc.id));
        });
        _badges = badges;
      });
    }
    return _badges;
  }

  Future restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }

  static void manageSubscriptions() {
    String url = Platform.isAndroid
        ? "https://play.google.com/store/account/subscriptions"
        : "https://apps.apple.com/account/subscriptions";
    launch(url);
  }
}
