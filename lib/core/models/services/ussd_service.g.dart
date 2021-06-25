// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ussd_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _USSDService implements USSDService {
  _USSDService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/ussd-code/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<List<USSDConfiguration>>> getUSSDConfigurations() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<USSDConfiguration>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'all',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<USSDConfiguration>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<USSDConfiguration>(
                (i) => USSDConfiguration.fromJson(i as Map<String, dynamic>))
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
