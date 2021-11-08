// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_product_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _SavingsProductService implements SavingsProductService {
  _SavingsProductService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-savings-service.development.teamapt.com/api/v1/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<SavingsProduct>> getFlexProduct() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<SavingsProduct>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '0.0.1'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'flex/saving/get-product',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<SavingsProduct>.fromJson(
      _result.data!,
      (json) => SavingsProduct.fromJson(json as Map<String, dynamic>),
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
