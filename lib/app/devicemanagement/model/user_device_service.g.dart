// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _UserDeviceService implements UserDeviceService {
  _UserDeviceService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://core-operations.monnify.development.teamapt.com/api/v1/device-management/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<List<UserDevice>>> getUserDevices(requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<UserDevice>>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'get-user-devices',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<UserDevice>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<UserDevice>(
                (i) => UserDevice.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServiceResult<bool>> deleteUserDevice(requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'remove-user-device',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
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
