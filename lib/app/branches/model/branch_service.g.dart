// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _BranchService implements BranchService {
  _BranchService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v1/monnify-branch/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<List<BranchInfo>>> getAllBranches(
      longitude, latitude, radiusInMiles) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'longitude': longitude,
      r'latitude': latitude,
      r'radiusInMiles': radiusInMiles
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<List<BranchInfo>>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.5'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'within-radius',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<List<BranchInfo>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<BranchInfo>(
                (i) => BranchInfo.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServiceResult<BranchInfoCollection>> searchBranchByName(name) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'name': name};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<BranchInfoCollection>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.5'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'search?',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<BranchInfoCollection>.fromJson(
      _result.data!,
      (json) => BranchInfoCollection.fromJson(json as Map<String, dynamic>),
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
