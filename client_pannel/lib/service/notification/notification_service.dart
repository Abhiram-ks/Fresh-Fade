import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  /// Initialize notification service with permissions
  static Future<void> initialize() async {
    // Android initialization settings
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the plugin
    await _plugin.initialize(initSettings);

    // Request permissions
    await requestPermissions();
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Android 13+ requires runtime permission
      final status = await Permission.notification.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      // iOS permissions
      final result = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return true;
  }

  /// Check if notification permissions are granted
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      return await Permission.notification.isGranted;
    } else if (Platform.isIOS) {
      final result = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.checkPermissions();
      return result?.isEnabled ?? false;
    }
    return true;
  }


  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {

    const androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(0, title, body, details, payload: payload);
  }
}