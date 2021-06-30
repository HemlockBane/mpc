// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airtime_beneficiary_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AirtimeBeneficiaryService implements AirtimeBeneficiaryService {
  _AirtimeBeneficiaryService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/airtime_beneficiary/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<AirtimeBeneficiaryCollection>> getAirtimeBeneficiaries(
      {page = 0, pageSize = 20}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'pageSize': pageSize
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<AirtimeBeneficiaryCollection>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'paged',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<AirtimeBeneficiaryCollection>.fromJson(
      _result.data!,
      (json) =>
          AirtimeBeneficiaryCollection.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<List<AirtimeBeneficiary>>>
      getFrequentBeneficiaries() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<AirtimeBeneficiary>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<AirtimeBeneficiary>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<AirtimeBeneficiary>(
                (i) => AirtimeBeneficiary.fromJson(i as Map<String, dynamic>))
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
                  r'appVersion': '1.0.4'
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
