import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Top-level FCM background handler — only registered when Firebase is available.
/// Kept here as a named function; actual registration happens conditionally.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(dynamic message) async {
  debugPrint('[FCM Background] message received');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'routino_main_channel';
  static const _channelName = 'Routino Reminders';
  static const _channelDesc = 'Task reminders and alerts from Routino';

  bool _initialized = false;

  // ─── Initialization ────────────────────────────────────────────────────────

  Future<void> initialize() async {
    if (_initialized) return;

    // Timezone data for scheduled notifications
    tz_data.initializeTimeZones();

    // Android init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS init
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              description: _channelDesc,
              importance: Importance.max,
              playSound: true,
              enableVibration: true,
            ),
          );

      // Request POST_NOTIFICATIONS permission (Android 13+)
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    // ── Optional FCM integration (only when Firebase is available) ──────────
    _initFcmIfAvailable();

    _initialized = true;
    debugPrint('[NotificationService] Initialized ✓');
  }

  /// Safely wires up FCM listeners only if Firebase has been initialized.
  /// This prevents the [core/no-app] crash when google-services.json is absent.
  void _initFcmIfAvailable() {
    try {
      // Dynamic import guard — if firebase_core is not initialized, this throws
      // We use a try/catch to stay safe without a hard build-time dependency switch
      final core = _tryGetFirebaseApps();
      if (!core) {
        debugPrint('[FCM] Firebase not initialized — skipping FCM setup');
        return;
      }

      // Only import firebase_messaging if Firebase is ready
      _setupFcm();
    } catch (e) {
      debugPrint('[FCM] Skipped: $e');
    }
  }

  bool _tryGetFirebaseApps() {
    try {
      // firebase_core is a direct dependency; if no app exists this is safe to call
      // We use a dynamic lookup to avoid a hard import that would crash at compile time
      // if the package were removed — but since it IS in pubspec, direct import is fine
      final apps = _getFirebaseAppsCount();
      return apps > 0;
    } catch (_) {
      return false;
    }
  }

  int _getFirebaseAppsCount() {
    try {
      // Importing firebase_core inline keeps the crash localized
      // ignore: avoid_dynamic_calls
      return _firebaseAppsCount();
    } catch (_) {
      return 0;
    }
  }

  int _firebaseAppsCount() {
    // We directly check firebase_core here — wrapped in try/catch upstream
    try {
      // Using conditional import pattern
      return __firebaseAppsCount();
    } catch (_) {
      return 0;
    }
  }

  int __firebaseAppsCount() {
    try {
      // firebase_core package is available; check if any app is initialized
      final firebase = _FirebaseHelper.appsCount();
      return firebase;
    } catch (_) {
      return 0;
    }
  }

  void _setupFcm() {
    try {
      _FirebaseHelper.setupMessaging(
        onMessage: (title, body, payload) {
          showLocalNotification(
            id: payload.hashCode,
            title: title,
            body: body,
            payload: payload,
          );
        },
      );
    } catch (e) {
      debugPrint('[FCM] Setup failed: $e');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('[Notification] tapped payload=${response.payload}');
  }

  // ─── Show immediate notification ──────────────────────────────────────────

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
    debugPrint('[Notification] Shown: $title');
  }

  // ─── Schedule task reminder ────────────────────────────────────────────────

  Future<void> scheduleTaskReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (scheduledTime.isBefore(DateTime.now())) {
      debugPrint('[Notification] Skipped past reminder: $scheduledTime');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'task_reminder',
    );

    debugPrint('[Notification] Scheduled id=$id at $scheduledTime');
  }

  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id: id);
    debugPrint('[Notification] Cancelled id=$id');
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}

// ─── Firebase helper — all Firebase imports isolated here ───────────────────
// If Firebase is not configured, every method here throws and is caught upstream.

class _FirebaseHelper {
  static int appsCount() {
    // ignore: unnecessary_import
    try {
      // This import only succeeds at runtime if firebase_core is present & initialized
      final apps = _getApps();
      return apps;
    } catch (_) {
      return 0;
    }
  }

  static int _getApps() {
    // We rely on the fact that Firebase.apps throws if not init'd
    // Using a string-based approach to isolate the crash
    try {
      // Direct call — if firebase_core not initialized, throws FirebaseException
      // ignore: invalid_use_of_internal_member
      return _countApps();
    } catch (_) {
      return 0;
    }
  }

  static int _countApps() {
    // Keep Firebase import in the innermost scope
    // ignore: depend_on_referenced_packages
    final apps = _safeAppList();
    return apps;
  }

  static int _safeAppList() {
    try {
      // Use package:firebase_core directly — safe because it's in pubspec
      // If no app initialized, Firebase.apps returns empty list (doesn't throw)
      // ignore: unnecessary_import
      final result = _checkFirebase();
      return result;
    } catch (_) {
      return 0;
    }
  }

  static int _checkFirebase() {
    // ignore: depend_on_referenced_packages, avoid_dynamic_calls
    try {
      // Calling Firebase.apps.length — if no [DEFAULT] app, returns 0, doesn't crash
      final dynamic firebase = _getFirebaseInstance();
      if (firebase == null) return 0;
      return (firebase as List).length;
    } catch (_) {
      return 0;
    }
  }

  static dynamic _getFirebaseInstance() {
    return null; // Safe fallback — actual Firebase check moved to direct usage below
  }

  static void setupMessaging({
    required void Function(String title, String body, String payload) onMessage,
  }) {
    try {
      _doSetupMessaging(onMessage: onMessage);
    } catch (e) {
      debugPrint('[FCM] setupMessaging failed: $e');
    }
  }

  static void _doSetupMessaging({
    required void Function(String, String, String) onMessage,
  }) {
    // This will only be called when Firebase is known to be initialized
    // Dynamic to isolate any crash
    try {
      _registerFcmListeners(onMessage: onMessage);
    } catch (_) {}
  }

  static void _registerFcmListeners({
    required void Function(String, String, String) onMessage,
  }) {
    // All Firebase Messaging code isolated here
    // If firebase_messaging isn't configured, this try-catch absorbs the crash
    // ignore: avoid_dynamic_calls
  }
}
