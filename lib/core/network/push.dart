import 'dart:io';

import 'package:domi/main.dart';
import 'package:domi/provider/auth/auth_provider.dart';
import 'package:domi/screens/home/service/deliveries_available.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> initPlatformState(BuildContext context, String externalId) async {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setRequiresUserPrivacyConsent(true);

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
    print(
        "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    print(result.notification.additionalData);
    if (result.notification.additionalData != null) {
      context
          .read(authProvider)
          .setNewData(result.notification.additionalData!);
    }
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    print('FOREGROUND HANDLER CALLED WITH: ${event}');

    /// Display Notification, send null to not display
    event.complete(null);

    print(
        "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    if (event.notification.additionalData != null) {
      context
          .read(authProvider)
          .setNewData(event.notification.additionalData!);
    }
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
  });

  // NOTE: Replace with your own app ID from https://www.onesignal.com
  await OneSignal.shared.setAppId("790cb11e-3cd2-481e-ab1e-ca54d21df6dd");

  bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

  OneSignal.shared.disablePush(false);

  bool userProvidedPrivacyConsent =
      await OneSignal.shared.userProvidedPrivacyConsent();
  print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");
  if (Platform.isAndroid) {
    _handleConsent();
    if (!await AuthProvider.checkUserExternalIdOpenSignal(externalId)) {
      _handleSetExternalUserId(externalId);
    }
  } else {
    Future.delayed(Duration(seconds: 5), () {
      _askForConsent(externalId);
    });
  }
}

void _handleConsent() {
  OneSignal.shared.consentGranted(true);
}

void _handleSetExternalUserId(String externalId) async {
  try {
    print("Setting external user ID");
    final results = await OneSignal.shared.setExternalUserId(externalId);
    if (results == null) return;
    AuthProvider.setUserExternalIdOpenSignal(externalId);
  } catch (e) {
    print(e);
  }
}

void _askForConsent(String externalId) async {
  _handleConsent();
  if (!await AuthProvider.checkUserExternalIdOpenSignal(externalId)) {
    await OneSignal.shared.promptUserForPushNotificationPermission();
    bool allowed =
        await OneSignal.shared.promptUserForPushNotificationPermission();
    if (allowed) {
      _handleConsent();
      _handleSetExternalUserId(externalId);
    }
  }
}
