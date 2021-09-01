// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_configuration_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _SystemConfigurationService implements SystemConfigurationService {
  _SystemConfigurationService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://core-operations.monnify.development.teamapt.com/api/v1/system-configuration/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<List<SystemConfiguration>>> getAllSystemConfigs() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<SystemConfiguration>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<SystemConfiguration>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<SystemConfiguration>(
                (i) => SystemConfiguration.fromJson(i as Map<String, dynamic>))
            .toList());
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
