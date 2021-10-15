// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airtime_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AirtimeService implements AirtimeService {
  _AirtimeService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-vas-service-v2.console.teamapt.com/api/v1/airtime/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<TransactionStatus>> buySingleAirtime(
      airtimePurchaseRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(airtimePurchaseRequestBody?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<TransactionStatus>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.1.0'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'single',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<TransactionStatus>.fromJson(
      _result.data!,
      (json) => TransactionStatus.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<AirtimeHistoryCollection>> getSingleAirtimeHistory(
      airtimeHistoryRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(airtimeHistoryRequestBody?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<AirtimeHistoryCollection>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.1.0'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'history',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<AirtimeHistoryCollection>.fromJson(
      _result.data!,
      (json) => AirtimeHistoryCollection.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

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
                  r'appVersion': '1.1.0'
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
  Future<dynamic> downloadAirtimeReceipt(customerId, batchId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
            method: 'GET',
            headers: <String, dynamic>{
              r'client-id': 'ANDROID',
              r'appVersion': '1.1.0'
            },
            extra: _extra,
            responseType: ResponseType.stream)
        .compose(_dio.options, 'receipt/$customerId/$batchId',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
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
