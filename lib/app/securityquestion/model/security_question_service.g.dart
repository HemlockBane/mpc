// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_question_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _SecurityQuestionService implements SecurityQuestionService {
  _SecurityQuestionService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://core-operations.monnify.development.teamapt.com/api/v1/security_question';
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
                  r'appVersion': '0.0.1'
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
