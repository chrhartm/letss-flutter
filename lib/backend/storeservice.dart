import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:in_app_purchase/in_app_purchase.dart";
import 'package:letss_app/backend/userservice.dart';
import 'package:url_launcher/url_launcher.dart';
import "loggerservice.dart";
import 'dart:io' show Platform;

class StoreService {
  static final StoreService _store = StoreService._internalConstructor();

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  factory StoreService() {
    return _store;
  }

  StoreService._internalConstructor();

  void dispose() {
    _subscription.cancel();
  }

  void init() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    }) as StreamSubscription<List<PurchaseDetails>>;
  }

  // TODO
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        LoggerService.log("Pending: " + purchaseDetails.productID);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          LoggerService.log("Error: " + purchaseDetails.error.toString());
          //_handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = true; //await _verifyPurchase(purchaseDetails);
          if (valid) {
            LoggerService.log("Purchased ${purchaseDetails.productID}");

            UserService.updateSubscription(purchaseDetails.productID)
                .then((val) {
              if (val) {
                if (purchaseDetails.pendingCompletePurchase) {
                  return InAppPurchase.instance
                      .completePurchase(purchaseDetails);
                }
              } else {
                LoggerService.log(
                    "Failed to subscribe to ${purchaseDetails.productID}",
                    level: "e");
              }
            });
          } else {
            // TODO
          }
        }
      }
    });
  }

  Future<List<ProductDetails>?> getProducts(Set<String> _kIds) async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      LoggerService.log("Store is not available", level: "e");
      return null;
    } else {
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        LoggerService.log("Didn't find IDs: ${response.notFoundIDs}",
            level: "e");
      }
      List<ProductDetails> products = response.productDetails;
      return products;
    }
  }

  Future<bool> purchase(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    return InAppPurchase.instance
        .buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<Map<String, String>?> getBadges() {
    String storeId = Platform.isAndroid ? "playStoreId" : "appStoreId";
    return FirebaseFirestore.instance
        .collection("badges")
        .get()
        .then((snapshot) {
      Map<String, String> badges = Map();
      snapshot.docs.forEach((doc) {
        badges[doc.data()[storeId]] = doc.data()["badge"];
      });
      return badges;
    });
  }

  void restorePurchases() {
    InAppPurchase.instance.restorePurchases();
  }

  static void manageSubscriptions() {
    // TODO test if this actually works for google
    String url = Platform.isAndroid
        ? "https://play.google.com/store/account/subscriptions"
        : "https://apps.apple.com/account/subscriptions";
    launch(url);
  }
}
