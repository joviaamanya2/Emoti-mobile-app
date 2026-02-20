import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationService {
  // Singleton
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Call once in main()
  Future<void> init() async {
    tzdata.initializeTimeZones();

    _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );

    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(initSettings);
  }

  // ======================================================================
  //  METHOD EXPECTED BY EmotionDashboard
  // ======================================================================

  /// This is what your dashboard calls
  static Future<void> scheduleMoodNotification(String mood) async {
    await NotificationService().showImmediateEncouragement(mood);
  }

  // ======================================================================
  //  DAILY NOTIFICATION
  // ======================================================================

  Future<void> scheduleDailyEncouragement({
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      0,
      'Hello from EmotiConnect',
      _sampleEncouragement(),
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Encouragement',
          channelDescription: 'Daily mood reminders & supportive messages',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  // ======================================================================
  //  IMMEDIATE MOOD-BASED NOTIFICATION
  // ======================================================================

  Future<void> showImmediateEncouragement(String mood) async {
    await _plugin.show(
      1,
      'Nice check-in',
      _encouragementForMood(mood),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'immediate_channel',
          'Immediate Notifications',
          channelDescription: 'Instant encouragement messages',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  // ======================================================================
  //  MOOD MESSAGES
  // ======================================================================

  String _encouragementForMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
        return 'Keep that calm — a short walk or stretch will maintain it.';
      case 'stressed':
        return 'Pause and breathe slowly. You’re stronger than the moment.';
      case 'happy':
        return 'Beautiful! Share that positivity with someone today.';
      case 'angry':
        return 'Step away for a moment. A short reset makes a big difference.';
      case 'sad':
        return 'It’s okay to feel this way. Be gentle with yourself.';
      default:
        return _sampleEncouragement();
    }
  }

  String _sampleEncouragement() {
    return 'Take a deep breath and do one small thing that feels good.';
  }
}
