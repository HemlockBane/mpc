// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _OnBoardingService implements OnBoardingService {
  _OnBoardingService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-root-v2.console.teamapt.com/api/v1/onboarding';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<TransferBeneficiary>> getAccount(requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<TransferBeneficiary>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.6'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '/name_enquiry',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<TransferBeneficiary>.fromJson(
      _result.data!,
      (json) => TransferBeneficiary.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<OTP>> getOTP(requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(requestBody?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<OTP>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.6'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '/get_otp',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<OTP>.fromJson(
      _result.data!,
      (json) => OTP.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<ValidationKey>> validateOTP(body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<ValidationKey>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.6'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '/validate_otp',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<ValidationKey>.fromJson(
      _result.data!,
      (json) => ValidationKey.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> onBoardUser(body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.6'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '/',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<ServiceResult<AccountProfile>> createAccount(body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        ServiceResult<AccountProfile>>(Options(
            method: 'POST',
            headers: <String, dynamic>{
              r'Content-Type': 'application/json',
              r'client-id': 'ANDROID',
              r'appVersion': '1.0.6'
            },
            extra: _extra,
            contentType: 'application/json')
        .compose(_dio.options,
            'https://moniepoint-customer-root-v2.console.teamapt.com/api/v2/onboarding/onboard-user',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<AccountProfile>.fromJson(
      _result.data!,
      (json) => AccountProfile.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> checkUsername(username) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'username': username};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        ServiceResult<bool>>(Options(
            method: 'GET',
            headers: <String, dynamic>{
              r'Content-Type': 'application/json',
              r'client-id': 'ANDROID',
              r'appVersion': '1.0.6'
            },
            extra: _extra,
            contentType: 'application/json')
        .compose(_dio.options,
            'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/user/check_username',
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
