import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:south24/notification/notification_helper.dart';

class FcmHelper {
  static FcmHelper fcmHelper = FcmHelper();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  configureFcm() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    subscribeTopic();
    turnOnMessageingStream();
  }

  subscribeTopic() async {
    // subscribe to topic on each app start-up
    await FirebaseMessaging.instance.subscribeToTopic('news');
  }

  turnOnMessageingStream() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String title = message.notification?.title ?? "";
      String body = message.notification?.body ?? "";
      NotHelper.notHelper.showNotification(title, body);
    });
  }
}
