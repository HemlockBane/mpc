// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institution_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _InstitutionService implements InstitutionService {
  _InstitutionService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-root-v2.console.teamapt.com/api/v1/institution/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<List<AccountProvider>>> getAccountProviders() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<AccountProvider>>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'account_provider',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<AccountProvider>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<AccountProvider>(
                (i) => AccountProvider.fromJson(i as Map<String, dynamic>))
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
