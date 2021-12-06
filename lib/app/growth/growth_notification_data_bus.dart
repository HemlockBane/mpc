
import 'package:dio/dio.dart';
import 'package:moniepoint_flutter/app/growth/growth_notification_data_type.dart';
import 'package:moniepoint_flutter/app/growth/growth_notification_member.dart';
import 'package:moniepoint_flutter/app/growth/model/data/dashboard_banner_data.dart';
import 'package:moniepoint_flutter/app/growth/model/data/pop_up_notification_data.dart';
import 'package:moniepoint_flutter/app/growth/model/data/growth_notification.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';

import 'model/data/growth_notification_response_body.dart';

///@author Paul Okeke

///GrowthNotificationDataBus
///
abstract class GrowthNotificationDataBus {
  static GrowthNotificationDataBus getInstance() => _GrowthNotificationDataBusImpl.getInstance();

  void subscribe(GrowthNotificationMember member);

  void unsubscribe(GrowthNotificationMember member);

  void publish(GrowthNotificationDataType event);
}


///_GrowthNotificationDataBusImpl
///
class _GrowthNotificationDataBusImpl extends Interceptor implements GrowthNotificationDataBus  {

  _GrowthNotificationDataBusImpl._internal();

  static final _GrowthNotificationDataBusImpl _instance = _GrowthNotificationDataBusImpl._internal();

  static GrowthNotificationDataBus getInstance() => _instance;

  final Set<GrowthNotificationMember> _listeners = Set<GrowthNotificationMember>();

  @override
  void subscribe(GrowthNotificationMember member) {
    this._listeners.add(member);
  }

  @override
  void unsubscribe(GrowthNotificationMember member) {
    this._listeners.remove(member);
  }

  @override
  void publish(GrowthNotificationDataType event) {
    event.setDataBus(this);
    this._listeners.forEach((element) {
      return element.accept(event);
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final dynamic responseData = response.data;

    if(response.realUri.pathSegments.contains("login")) {
      final ServiceResult<User> data = ServiceResult.fromJson(responseData, (json) => User.fromJson(json));
      Future.delayed(Duration(seconds: 2), (){
        _handleGrowthNotifications(data.growthNotifications);
      });
      return super.onResponse(response, handler);
    }

    final ServiceResult<dynamic> data = ServiceResult.fromJson(responseData, (json) => null);

    if(data is ServiceResult<dynamic>) {
      final notifications = data.growthNotifications;
      _handleGrowthNotifications(notifications);
    }

    super.onResponse(response, handler);
  }

  void _handleGrowthNotifications(GrowthNotificationResponseBody? growthNotificationResponse) {
    if(growthNotificationResponse == null) return;

    final dashboardBanners = growthNotificationResponse.dashboardBanners ?? [];
    final popNotifications = growthNotificationResponse.popUpNotifications ?? [];

    if(dashboardBanners.isNotEmpty) this.publish(DashboardBannerData.of(dashboardBanners));
    if(popNotifications.isNotEmpty) this.publish(PopUpNotificationData.of(popNotifications));
  }

}