import 'package:firebase_analytics/firebase_analytics.dart';

void trackButtonClick(String buttonName) {
  FirebaseAnalytics.instance.logEvent(
    name: 'button_click',
    parameters: {'button_name': buttonName},
  );
}
