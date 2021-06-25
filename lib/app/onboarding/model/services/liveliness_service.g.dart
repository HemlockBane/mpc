// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liveliness_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _LivelinessService implements LivelinessService {
  _LivelinessService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/liveness-check/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<LivelinessChecks>> getLivelinessChecks() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<LivelinessChecks>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'challenges-and-problems',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<LivelinessChecks>.fromJson(
      _result.data!,
      (json) => LivelinessChecks.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<LivelinessCompareResponse>> compareAndGetImageReference(
      image, bvn) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'sourceImage',
        MultipartFile.fromFileSync(image.path,
            filename: image.path.split(Platform.pathSeparator).last)));
    _data.fields.add(MapEntry('bvn', bvn));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<LivelinessCompareResponse>>(Options(
                method: 'POST',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'compare-image',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<LivelinessCompareResponse>.fromJson(
      _result.data!,
      (json) =>
          LivelinessCompareResponse.fromJson(json as Map<String, dynamic>),
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
