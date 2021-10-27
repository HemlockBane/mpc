// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _TransferService implements TransferService {
  _TransferService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-transfer-v2.console.teamapt.com/api/v1/transfer/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<FeeVat>> getFeeVat(
      sinkAccountProviderCode, minorAmount) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'sinkAccountProviderCode': sinkAccountProviderCode,
      r'minorAmount': minorAmount
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<FeeVat>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.1.0'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<FeeVat>.fromJson(
      _result.data!,
      (json) => FeeVat.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<FeeVatConfig>> getAllFeeAndVatConfig() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<FeeVatConfig>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.1.0'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'all-fee-vat-configs',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<FeeVatConfig>.fromJson(
      _result.data!,
      (json) => FeeVatConfig.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<TransactionStatus>> doInstantTransfer(
      transferRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(transferRequestBody?.toJson() ?? <String, dynamic>{});
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
            .compose(_dio.options, './',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<TransactionStatus>.fromJson(
      _result.data!,
      (json) => TransactionStatus.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<TransferHistoryCollection>> getSingleTransferHistory(
      customerId, requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(requestBody?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<TransferHistoryCollection>>(Options(
                method: 'PUT',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.1.0'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '$customerId',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<TransferHistoryCollection>.fromJson(
      _result.data!,
      (json) =>
          TransferHistoryCollection.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<dynamic> downloadTransferReceipt(customerId, batchId) async {
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
