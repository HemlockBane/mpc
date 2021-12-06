// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_notification_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _GrowthNotificationService implements GrowthNotificationService {
  _GrowthNotificationService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-growth-service.development.teamapt.com/api/v1/notification/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<dynamic>> updateNotificationAction(
      notificationId, statusType) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'statusType': statusType};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<dynamic>>(Options(
                method: 'PATCH',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '$notificationId',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
