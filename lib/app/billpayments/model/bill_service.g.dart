// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _BillService implements BillService {
  _BillService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-vas-service-v2.console.teamapt.com/api/v1/bill/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<List<BillerProduct>>> getProductsByBiller(
      billerCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'billerCode': billerCode};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<BillerProduct>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'products_by_billers',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<BillerProduct>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<BillerProduct>(
                (i) => BillerProduct.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServiceResult<List<Biller>>> getBillersByCategory(categoryCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'categoryCode': categoryCode};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<Biller>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'billers_by_category',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<Biller>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<Biller>((i) => Biller.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServiceResult<List<BillerCategory>>> getBillerCategories() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<BillerCategory>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'categories',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<BillerCategory>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<BillerCategory>(
                (i) => BillerCategory.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServiceResult<TransactionStatus>> paySingleBill(requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(requestBody?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<TransactionStatus>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<TransactionStatus>.fromJson(
      _result.data!,
      (json) => TransactionStatus.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<BillHistoryCollection>> getBillHistory(
      billHistoryRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(billHistoryRequestBody?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<BillHistoryCollection>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'history',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<BillHistoryCollection>.fromJson(
      _result.data!,
      (json) => BillHistoryCollection.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<BillValidationStatus>> validateCustomerBillPayment(
      customerId, paymentCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'customerId': customerId,
      r'productCode': paymentCode
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<BillValidationStatus>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'validate',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<BillValidationStatus>.fromJson(
      _result.data!,
      (json) => BillValidationStatus.fromJson(json as Map<String, dynamic>),
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
              r'appVersion': '1.0.8'
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
