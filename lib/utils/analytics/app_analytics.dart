import 'package:al_quran/utils/analytics/analytics_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AppAnalytics {
  static  FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Initialize Firebase Analytics
  static void initialize()  {
    _analytics = FirebaseAnalytics.instance;
  }

  // Track custom events with optional parameters
  static Future<void> logEvent({
    required AnalyticsEvent event,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: event.name,
      parameters: _parametersToStringMap(parameters),
    );
  }

  // Track screen views
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
      parameters: _parametersToStringMap(parameters),
    );
  }

  static _parametersToStringMap(Map<String, Object>? parameters) {
    if (parameters == null) return null;
    return parameters.map((key, value) => (value is num)
        ? MapEntry(key, value)
        : MapEntry(key, value.toString()));
  }
}
