import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Request permission and get FCM token
  Future<String?> getFCMToken() async {
    try {
      // Request permission (iOS only)
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get FCM token
        String? token = await _messaging.getToken();
        debugPrint("FCM Token: $token");
        return token;
      } else {
        debugPrint("User declined or has not accepted permission");
        return null;
      }
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
      return null;
    }
  }

  // Listen to token refresh
  void listenToTokenRefresh(Function(String) onTokenRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint("FCM Token refreshed: $newToken");
      onTokenRefresh(newToken);
    });
  }

  // Setup foreground notification handler
  void setupForegroundNotificationHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground message received: ${message.notification?.title}");
      // Handle notification when app is in foreground
    });
  }

  // Setup background notification handler
  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    debugPrint("Background message received: ${message.notification?.title}");
    // Handle background notification
  }
}