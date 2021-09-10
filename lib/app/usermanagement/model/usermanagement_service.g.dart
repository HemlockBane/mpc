// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usermanagement_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _UserManagementService implements UserManagementService {
  _UserManagementService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<RecoveryResponse>> forgotUsername(step, key,
      {userCode, otp, otpValidationKey, firstCapture, motionCapture}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = FormData();
    if (step != null) {
      _data.fields.add(MapEntry('step', step));
    }
    if (key != null) {
      _data.fields.add(MapEntry('key', key));
    }
    if (userCode != null) {
      _data.fields.add(MapEntry('userCode', userCode));
    }
    if (otp != null) {
      _data.fields.add(MapEntry('otp', otp));
    }
    if (otpValidationKey != null) {
      _data.fields.add(MapEntry('otpValidationKey', otpValidationKey));
    }
    if (firstCapture != null) {
      _data.files.add(MapEntry(
          'image1',
          MultipartFile.fromFileSync(firstCapture.path,
              filename: firstCapture.path.split(Platform.pathSeparator).last,
              contentType: MediaType.parse('application/json'))));
    }
    if (motionCapture != null) {
      _data.files.add(MapEntry(
          'image2',
          MultipartFile.fromFileSync(motionCapture.path,
              filename: motionCapture.path.split(Platform.pathSeparator).last,
              contentType: MediaType.parse('application/json'))));
    }
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<RecoveryResponse>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'multipart/form-data',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'multipart/form-data')
            .compose(_dio.options, 'v2/user/forgot_username',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<RecoveryResponse>.fromJson(
      _result.data!,
      (json) => RecoveryResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<RecoveryResponse>> forgotPassword(step, key,
      {userCode,
      otp,
      livelinessCheckRef,
      password,
      otpValidationKey,
      firstCapture,
      motionCapture}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = FormData();
    if (step != null) {
      _data.fields.add(MapEntry('step', step));
    }
    if (key != null) {
      _data.fields.add(MapEntry('username', key));
    }
    if (userCode != null) {
      _data.fields.add(MapEntry('userCode', userCode));
    }
    if (otp != null) {
      _data.fields.add(MapEntry('otp', otp));
    }
    if (livelinessCheckRef != null) {
      _data.fields.add(MapEntry('livelinessCheckRef', livelinessCheckRef));
    }
    if (password != null) {
      _data.fields.add(MapEntry('password', password));
    }
    if (otpValidationKey != null) {
      _data.fields.add(MapEntry('otpValidationKey', otpValidationKey));
    }
    if (firstCapture != null) {
      _data.files.add(MapEntry(
          'image1',
          MultipartFile.fromFileSync(firstCapture.path,
              filename: firstCapture.path.split(Platform.pathSeparator).last,
              contentType: MediaType.parse('application/json'))));
    }
    if (motionCapture != null) {
      _data.files.add(MapEntry(
          'image2',
          MultipartFile.fromFileSync(motionCapture.path,
              filename: motionCapture.path.split(Platform.pathSeparator).last,
              contentType: MediaType.parse('application/json'))));
    }
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<RecoveryResponse>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'multipart/form-data',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'multipart/form-data')
            .compose(_dio.options, 'v2/user/forgot_password',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<RecoveryResponse>.fromJson(
      _result.data!,
      (json) => RecoveryResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> completeForgotPassword(step, key,
      {livelinessCheckRef, password}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = FormData();
    if (step != null) {
      _data.fields.add(MapEntry('step', step));
    }
    if (key != null) {
      _data.fields.add(MapEntry('username', key));
    }
    if (livelinessCheckRef != null) {
      _data.fields.add(MapEntry('livelinessCheckRef', livelinessCheckRef));
    }
    if (password != null) {
      _data.fields.add(MapEntry('password', password));
    }
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'v2/user/forgot_password',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<ServiceResult<OTP>> sendForgotPasswordOtp(request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<OTP>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'v2/user/forgot_password/send_otp',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<OTP>.fromJson(
      _result.data!,
      (json) => OTP.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<OTP>> sendForgotUsernameOtp(request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<OTP>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'v2/user/forgot_username/send_otp',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<OTP>.fromJson(
      _result.data!,
      (json) => OTP.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> changeTransactionPin(requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(Options(
                method: 'PUT',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'v1/user/change_transaction_pin',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> changePassword(requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(Options(
                method: 'PUT',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'v1/user/change_password',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> setFingerprint(requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(requestBody?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(Options(
                method: 'PUT',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.8'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'v1/user/set_fingerprint',
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
