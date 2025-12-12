import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class NotificationService {
  
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const linux = LinuxInitializationSettings(defaultActionName: 'Open notification');
    const settings = InitializationSettings(
      android: android,
      linux: linux,
    );
    await _notifications.initialize(settings);
    tz.initializeTimeZones();
  }

static Future<void> scheduleNotification(String title, String body, DateTime dateTime) async {
    await _notifications.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}