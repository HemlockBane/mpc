// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_question_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _SecurityQuestionService implements SecurityQuestionService {
  _SecurityQuestionService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/security_question';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<List<SecurityQuestion>>> getAllQuestions() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<SecurityQuestion>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '/questions',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<SecurityQuestion>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<SecurityQuestion>(
                (i) => SecurityQuestion.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServiceResult<SecurityQuestion>> getQuestionByUsername(
      requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<SecurityQuestion>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '/by_username',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<SecurityQuestion>.fromJson(
      _result.data!,
      (json) => SecurityQuestion.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<SecurityQuestion>> getQuestionByAccountNumber(
      requestBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestBody.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<SecurityQuestion>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, '/by_account_number',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<SecurityQuestion>.fromJson(
      _result.data!,
      (json) => SecurityQuestion.fromJson(json as Map<String, dynamic>),
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
