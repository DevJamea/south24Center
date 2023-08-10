import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotHelper {
  static NotHelper notHelper = NotHelper();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  configureNotification() {
    // Create an instance of the FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Request permissions for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null, // No iOS initialization settings needed for version 8.2.0
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // If you want to handle notification callbacks when the app is in the foreground,
    // uncomment the following line
    // flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: yourCallbackMethod);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('1', // channel ID
      'Notification', // channel name
      'News Notification',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      1, // notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
