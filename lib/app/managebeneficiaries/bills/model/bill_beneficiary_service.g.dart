// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_beneficiary_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _BillBeneficiaryService implements BillBeneficiaryService {
  _BillBeneficiaryService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://core-operations.monnify.development.teamapt.com/api/v1/biller_beneficiary/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<BillBeneficiaryCollection>> getBillerBeneficiaries(
      customerId, page, pageSize) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'pageSize': pageSize
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<BillBeneficiaryCollection>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.6'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'paged/$customerId',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<BillBeneficiaryCollection>.fromJson(
      _result.data!,
      (json) =>
          BillBeneficiaryCollection.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<List<BillBeneficiary>>> getFrequentBeneficiaries(
      limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<BillBeneficiary>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.6'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'frequent/$limit',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<BillBeneficiary>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<BillBeneficiary>(
                (i) => BillBeneficiary.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServiceResult<bool>> deleteBeneficiary(id, customerId, pin) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'id': id,
      r'customerId': customerId,
      r'pin': pin
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.6'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'delete',
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
