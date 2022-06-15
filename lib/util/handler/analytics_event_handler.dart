import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsEventsHandler {

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static void logEvent(String eventName, {Map<String, Object?>? data}) async {
    _analytics.logEvent(
      name: eventName,
      parameters: data
    );
  }
}
