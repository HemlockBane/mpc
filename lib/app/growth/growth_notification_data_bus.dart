
import 'package:dio/dio.dart';
import 'package:moniepoint_flutter/app/growth/growth_notification_data_type.dart';
import 'package:moniepoint_flutter/app/growth/growth_notification_member.dart';
import 'package:moniepoint_flutter/app/growth/model/data/dashboard_banner_data.dart';
import 'package:moniepoint_flutter/app/growth/model/data/pop_up_notification_data.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';

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
    this._listeners.forEach((element) => element.accept(event));
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final dynamic data = response.data;
    if(data is ServiceResult<dynamic>) {
      final notifications = data.notifications;

      if(notifications == null) return super.onResponse(response, handler);

      final dashboardBanners = notifications.dashboardBanners ?? [];
      final popNotifications = notifications.popUpNotifications ?? [];

      dashboardBanners.forEach((banner) => this.publish(DashboardBannerData.of(banner)));
      if(popNotifications.isNotEmpty) this.publish(PopUpNotificationData.of(popNotifications));
    }
    super.onResponse(response, handler);
  }

}