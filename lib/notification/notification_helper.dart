import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotHelper {
  static final NotHelper notHelper = NotHelper();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> configureNotification() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('app_icon');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // handle tap
        final payload = response.payload;
        // TODO: navigate / do action based on payload
      },
      // لو بدك تعامل مع ضغط الإشعار والاب مغلق (اختياري):
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      '1',
      'Notification',
      channelDescription: 'News Notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: 1,
      title: title,
      body: body,
      notificationDetails: details,
      // payload: 'any', // اختياري
    );
  }
}
