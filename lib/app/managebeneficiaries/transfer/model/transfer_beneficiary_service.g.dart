// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_beneficiary_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _TransferBeneficiaryService implements TransferBeneficiaryService {
  _TransferBeneficiaryService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://core-operations.monnify.development.teamapt.com/api/v1/beneficiary/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<TransferBeneficiaryCollection>> getAccountBeneficiaries(
      {page = 0, pageSize = 20}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'pageSize': pageSize
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<TransferBeneficiaryCollection>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'paged',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<TransferBeneficiaryCollection>.fromJson(
      _result.data!,
      (json) =>
          TransferBeneficiaryCollection.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<List<TransferBeneficiary>>>
      getFrequentBeneficiaries() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<TransferBeneficiary>>>(Options(
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
    final value = ServiceResult<List<TransferBeneficiary>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<TransferBeneficiary>(
                (i) => TransferBeneficiary.fromJson(i as Map<String, dynamic>))
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
