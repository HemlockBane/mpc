import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/notifications/model/handlers/notification_handler.dart';
import 'package:moniepoint_flutter/core/routes.dart';

///@author Paul Okeke
///
///@class NotificationRouteObserver
///
class NotificationRouteObserver extends RouteObserver<ModalRoute<dynamic>> {

  void _checkNavigation(Route newRoute, Route oldRoute) {
    if(newRoute.settings.name != Routes.DASHBOARD && oldRoute.settings.name != "/") {
      return;
    }
    NotificationHandler.dispatchPendingNotification();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if(previousRoute == null) return;
    _checkNavigation(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if(previousRoute == null) return;
    _checkNavigation(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    if(previousRoute == null) return;
    _checkNavigation(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if(oldRoute == null || newRoute == null) return;
    _checkNavigation(newRoute, oldRoute);
  }
}