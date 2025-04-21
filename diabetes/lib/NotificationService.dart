import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static const String channelId = 'diabetes_channel_id';
  static const String channelName = 'Diabetes Notifications';
  static const String channelDescription =
      'Notifications for diabetes reminders';

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.high,
    priority: Priority.high,
  );

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidDetails,
  );

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  ////////////////////////////////////////////////////////
  Future<void> scheduleDailyReminders() async {
    const List<String> reminders = [
      "Time for breakfast! Check your blood glucose and log your meal.",
      "Time to take your medication! Don't forget to log your data.",
      "It's lunch time! Don't forget to monitor your health.",
      "Dinner is ready! Take your medication and log your meal."
    ];
    final now = DateTime.now();

    final List<DateTime> times = [
      DateTime(now.year, now.month, now.day, 8, 0), // 8:00 AM
      DateTime(now.year, now.month, now.day, 10, 30), // 10:30 AM
      DateTime(now.year, now.month, now.day, 14, 30), // 2:30 PM
      DateTime(now.year, now.month, now.day, 20, 00), // 8:00 PM
    ];

    for (int i = 0; i < reminders.length; i++) {
      final scheduledTime = times[i].isBefore(now)
          ? times[i].add(const Duration(days: 1))
          : times[i];
      await flutterLocalNotificationsPlugin.zonedSchedule(
        i,
        'Daily Reminder',
        reminders[i],
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel',
            'Daily Reminders',
            channelDescription: 'Reminders for meals and health checks',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

// Helper to check if user has logged data today
  Future<void> scheduleDailyLogsReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminder',
      channelDescription: 'Reminder to log your glucose data',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Reminder',
      'Don\'t forget to log your glucose data today!',
      tz.TZDateTime.from(_nextInstanceOfReminderTime(), tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  DateTime _nextInstanceOfReminderTime() {
    final now = DateTime.now();
    final reminderTime =
        DateTime(now.year, now.month, now.day, 20, 0, 0); // 8 PM
    return now.isAfter(reminderTime)
        ? reminderTime.add(const Duration(days: 1))
        : reminderTime;
  }

/*
Future<void> sendReminderIfNoLogs() async {

  final hasLogged = await hasLoggedToday();
  if (!hasLogged) {
    scheduleDailyLogsReminder();
  } else {
    await flutterLocalNotificationsPlugin.cancel(0); // Cancel scheduled reminder
  }
}*/

// Helper to convert `Time` to TZDateTime
  tz.TZDateTime _convertToTZDateTime(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time has already passed for today, schedule for tomorrow
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  static Future<void> showDailyReminder(
      String task, int id, DateTime time) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Reminder',
      task,
      tz.TZDateTime.from(time, tz.local),
      _notificationDetails,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  static Future<void> showAbnormalReadingAlert(String message) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Abnormal Reading Alert',
      body: message,
    );
  }
}

// Additional Helper Methods
void scheduleAppointmentNotification(DateTime appointmentTime) {
  NotificationService.scheduleNotification(
    id: appointmentTime.millisecondsSinceEpoch ~/ 1000,
    title: 'Upcoming Appointment',
    body: 'You have an appointment scheduled tomorrow.',
    scheduledTime: appointmentTime.subtract(const Duration(days: 1)),
  );

  NotificationService.scheduleNotification(
    id: (appointmentTime.millisecondsSinceEpoch ~/ 1000) + 1,
    title: 'Appointment Reminder',
    body: 'Your appointment is in 1 hour.',
    scheduledTime: appointmentTime.subtract(const Duration(hours: 1)),
  );
}

void monitorUserActivity() async {
  final prefs = await SharedPreferences.getInstance();
  final lastLogTime = prefs.getString('last_log_time') ?? '';
  if (lastLogTime.isEmpty ||
      DateTime.parse(lastLogTime)
          .isBefore(DateTime.now().subtract(const Duration(hours: 24)))) {
    NotificationService.showNotification(
      id: 3,
      title: 'Log Your Data',
      body: 'We noticed you haven’t logged your data today.',
    );
  }
}

void showCriticalAlert(String message) {
  NotificationService.showNotification(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: 'Emergency Alert',
    body: message,
  );
}
