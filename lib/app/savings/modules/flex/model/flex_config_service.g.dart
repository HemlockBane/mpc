// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_config_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _FlexConfigService implements FlexConfigService {
  _FlexConfigService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-savings-service.development.teamapt.com/api/v1/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<FlexSavingConfig>> createCustomerFlexConfig(
      request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<FlexSavingConfig>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'flex/saving/create-customer-config',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<FlexSavingConfig>.fromJson(
      _result.data!,
      (json) => FlexSavingConfig.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<FlexSavingConfig>> updateCustomerFlexConfig(
      flexSavingConfigId, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'existingFlexConfigId': flexSavingConfigId
    };
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<FlexSavingConfig>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'flex/saving/update-customer-config',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<FlexSavingConfig>.fromJson(
      _result.data!,
      (json) => FlexSavingConfig.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<FlexSavingConfig>> getFlexSavingConfig(
      flexSavingConfigId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'flexSavingConfigId': flexSavingConfigId
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<FlexSavingConfig>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'flex/saving/get-customer-config',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<FlexSavingConfig>.fromJson(
      _result.data!,
      (json) => FlexSavingConfig.fromJson(json as Map<String, dynamic>),
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
