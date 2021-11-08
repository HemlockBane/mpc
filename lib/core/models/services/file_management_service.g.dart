// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_management_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _FileManagementService implements FileManagementService {
  _FileManagementService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/file-management/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<FileResult>> getFile(fileUUID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'fileUUID': fileUUID};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<FileResult>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.1.0'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'get-file',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<FileResult>.fromJson(
      _result.data!,
      (json) => FileResult.fromJson(json as Map<String, dynamic>),
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
