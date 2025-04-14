import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AnalyticsObserver extends RouteObserver<ModalRoute<dynamic>> {
  final FirebaseAnalytics analytics;

  AnalyticsObserver({required this.analytics});

  void _sendScreenView(Route<dynamic> route) {
    var routeName = route.settings.name;
    if (routeName == null) return;

    analytics.logEvent(
      name: 'screen_view',
      parameters: {'screen_name': routeName},
    );

    analytics.setCurrentScreen(
      screenName: routeName,
      screenClassOverride: routeName,
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _sendScreenView(route);
  }
}