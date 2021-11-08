// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _CardService implements CardService {
  _CardService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-root-v2.console.teamapt.com/api/v1/card/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<List<Card>>> getCards(customerAccountId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<Card>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.1.0'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'get_cards/$customerAccountId',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<Card>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<Card>((i) => Card.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServiceResult<bool>> blockCardChannel(
      customerAccountId, cardChannelRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'customerId': customerAccountId};
    final _data = <String, dynamic>{};
    _data.addAll(cardChannelRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'block_card_channel',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> changeCardPin(
      customerAccountId, cardChannelRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'customerId': customerAccountId};
    final _data = <String, dynamic>{};
    _data.addAll(cardChannelRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'change_card_pin',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> unblockCardChannel(
      customerAccountId, cardChannelRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'customerId': customerAccountId};
    final _data = <String, dynamic>{};
    _data.addAll(cardChannelRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'unblock_card_channel',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> blockCard(customerAccountId, blockRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'customerId': customerAccountId};
    final _data = <String, dynamic>{};
    _data.addAll(blockRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'block_card',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<ServiceResult<bool>> unblockCard(
      customerAccountId, unblockRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'customerId': customerAccountId};
    final _data = <String, dynamic>{};
    _data.addAll(unblockRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<bool>>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'unblock_card',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<ServiceResult<CardRequestBalanceResponse>>
      confirmAccountBalanceIsSufficient(accountNumber) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'accountNumber': accountNumber};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<CardRequestBalanceResponse>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'check-sufficient-balance',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<CardRequestBalanceResponse>.fromJson(
      _result.data!,
      (json) =>
          CardRequestBalanceResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<CardOtpLinkingResponse>> sendCardLinkingOtp(
      customerAccountId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        ServiceResult<CardOtpLinkingResponse>>(Options(
            method: 'GET', headers: <String, dynamic>{}, extra: _extra)
        .compose(_dio.options,
            'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/card/send_card_linking_otp/customer_account_id/$customerAccountId',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<CardOtpLinkingResponse>.fromJson(
      _result.data!,
      (json) => CardOtpLinkingResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<CardOtpValidationResponse>> validateCardLinkingOtp(
      customerAccountId, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        ServiceResult<CardOtpValidationResponse>>(Options(
            method: 'POST', headers: <String, dynamic>{}, extra: _extra)
        .compose(_dio.options,
            'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/card/validate_card_linking_otp/customer_account_id/$customerAccountId',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<CardOtpValidationResponse>.fromJson(
      _result.data!,
      (json) =>
          CardOtpValidationResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<CardLinkingResponse>> linkCard(customerId,
      customerAccountId, firstCapture, motionCapture, otpValidationKey,
      {customerCode, cardSerial}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'customerId': customerId};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry('customerAccountId', customerAccountId));
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
    if (otpValidationKey != null) {
      _data.fields.add(MapEntry('OtpValidationKey', otpValidationKey));
    }
    if (customerCode != null) {
      _data.fields.add(MapEntry('customerCode', customerCode));
    }
    if (cardSerial != null) {
      _data.fields.add(MapEntry('cardSerial', cardSerial));
    }
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<CardLinkingResponse>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'multipart/form-data',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.1.0'
                },
                extra: _extra,
                contentType: 'multipart/form-data')
            .compose(_dio.options, 'link-card',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<CardLinkingResponse>.fromJson(
      _result.data!,
      (json) => CardLinkingResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<CardActivationResponse>> activateCard(
      customerId,
      customerAccountId,
      firstCapture,
      motionCapture,
      customerCode,
      cardId,
      cvv2,
      newPin) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'customerId': customerId};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry('customerAccountId', customerAccountId));
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
    _data.fields.add(MapEntry('customerCode', customerCode));
    if (cardId != null) {
      _data.fields.add(MapEntry('cardId', cardId.toString()));
    }
    if (cvv2 != null) {
      _data.fields.add(MapEntry('cvv2', cvv2));
    }
    if (newPin != null) {
      _data.fields.add(MapEntry('newPin', newPin));
    }
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<CardActivationResponse>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'multipart/form-data',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.1.0'
                },
                extra: _extra,
                contentType: 'multipart/form-data')
            .compose(_dio.options, 'activate-card',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<CardActivationResponse>.fromJson(
      _result.data!,
      (json) => CardActivationResponse.fromJson(json as Map<String, dynamic>),
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
