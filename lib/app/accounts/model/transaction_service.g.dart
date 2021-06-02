// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _TransactionService implements TransactionService {
  _TransactionService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://core-root.monnify.development.teamapt.com/api/v1/transactions/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<TransactionHistoryCollection>> getTransactionsFilter(
      customerAccountId,
      transactionType,
      channels,
      startDate,
      endDate,
      page,
      pageSize) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'customerAccountId': customerAccountId,
      r'transactionType': transactionType,
      r'channel': channels,
      r'startDate': startDate,
      r'endDate': endDate,
      r'page': page,
      r'pageSize': pageSize
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<TransactionHistoryCollection>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'filter',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<TransactionHistoryCollection>.fromJson(
      _result.data!,
      (json) =>
          TransactionHistoryCollection.fromJson(json as Map<String, dynamic>),
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
