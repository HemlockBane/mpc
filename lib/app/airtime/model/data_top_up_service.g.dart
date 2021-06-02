// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_top_up_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _DataTopUpService implements DataTopUpService {
  _DataTopUpService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://core-vas.monnify.development.teamapt.com/api/v1/data-topup/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<List<AirtimeServiceProvider>>>
      getServiceProviders() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<AirtimeServiceProvider>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'providers',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<AirtimeServiceProvider>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<AirtimeServiceProvider>((i) =>
                AirtimeServiceProvider.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServiceResult<List<AirtimeServiceProviderItem>>>
      getServiceProviderItems(billerId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<AirtimeServiceProviderItem>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'data-provider-items/$billerId',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<AirtimeServiceProviderItem>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<AirtimeServiceProviderItem>((i) =>
                AirtimeServiceProviderItem.fromJson(i as Map<String, dynamic>))
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
