// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ValidationService implements ValidationService {
  _ValidationService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-root-v2.console.teamapt.com/api/v1/authentication';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<OTP>> triggerOTP(username) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('username', username));
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        ServiceResult<OTP>>(Options(
            method: 'POST',
            headers: <String, dynamic>{
              r'Content-Type': 'multipart/form-data',
              r'client-id': 'ANDROID',
              r'appVersion': '1.1.0'
            },
            extra: _extra,
            contentType: 'multipart/form-data')
        .compose(_dio.options,
            'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/switch-device/trigger-otp',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<OTP>.fromJson(
      _result.data!,
      (json) => OTP.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<ValidateAnswerResponse>> validateOtp(
      username, otp, userCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('username', username));
    _data.fields.add(MapEntry('otp', otp));
    _data.fields.add(MapEntry('userCode', userCode));
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        ServiceResult<ValidateAnswerResponse>>(Options(
            method: 'POST',
            headers: <String, dynamic>{
              r'Content-Type': 'multipart/form-data',
              r'client-id': 'ANDROID',
              r'appVersion': '1.1.0'
            },
            extra: _extra,
            contentType: 'multipart/form-data')
        .compose(_dio.options,
            'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/switch-device/validate-otp',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<ValidateAnswerResponse>.fromJson(
      _result.data!,
      (json) => ValidateAnswerResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> editDevice(editDeviceRequestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(editDeviceRequestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        ServiceResult<bool>>(Options(
            method: 'POST',
            headers: <String, dynamic>{
              r'Content-Type': 'application/json',
              r'client-id': 'ANDROID',
              r'appVersion': '1.1.0'
            },
            extra: _extra,
            contentType: 'application/json')
        .compose(_dio.options,
            'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/switch-device/register-device',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<ServiceResult<ValidateAnswerResponse>> validateLivelinessForDevice(
      firstCapture, motionCapture, otpValidationKey, username) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'image1',
        MultipartFile.fromFileSync(firstCapture.path,
            filename: firstCapture.path.split(Platform.pathSeparator).last,
            contentType: MediaType.parse('application/json'))));
    _data.files.add(MapEntry(
        'image2',
        MultipartFile.fromFileSync(motionCapture.path,
            filename: motionCapture.path.split(Platform.pathSeparator).last,
            contentType: MediaType.parse('application/json'))));
    _data.fields.add(MapEntry('validationKey', otpValidationKey));
    _data.fields.add(MapEntry('username', username));
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        ServiceResult<ValidateAnswerResponse>>(Options(
            method: 'POST',
            headers: <String, dynamic>{
              r'Content-Type': 'multipart/form-data',
              r'client-id': 'ANDROID',
              r'appVersion': '1.1.0'
            },
            extra: _extra,
            contentType: 'multipart/form-data')
        .compose(_dio.options,
            'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/switch-device/liveliness-check',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<ValidateAnswerResponse>.fromJson(
      _result.data!,
      (json) => ValidateAnswerResponse.fromJson(json as Map<String, dynamic>),
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
