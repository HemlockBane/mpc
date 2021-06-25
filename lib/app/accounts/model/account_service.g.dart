// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AccountService implements AccountService {
  _AccountService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-root-v2.console.teamapt.com/api/v1/account/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<AccountBalance>> getCustomerAccountBalance(
      customerAccountId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'customerAccountId': customerAccountId
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<AccountBalance>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'account-balance',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<AccountBalance>.fromJson(
      _result.data!,
      (json) => AccountBalance.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<AccountStatus>> getAccountStatus(
      customerAccountId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'customerAccountId': customerAccountId
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<AccountStatus>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'status',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<AccountStatus>.fromJson(
      _result.data!,
      (json) => AccountStatus.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServiceResult<TransferBeneficiary>> getBeneficiaryDetails(
      accountProviderCode, accountNumber) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'accountProviderCode': accountProviderCode,
      r'accountNumber': accountNumber
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<TransferBeneficiary>>(Options(
                method: 'GET',
                headers: <String, dynamic>{
                  r'Content-Type': 'application/json',
                  r'client-id': 'ANDROID',
                  r'appVersion': '1.0.4'
                },
                extra: _extra,
                contentType: 'application/json')
            .compose(_dio.options, 'account-name',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceResult<TransferBeneficiary>.fromJson(
      _result.data!,
      (json) => TransferBeneficiary.fromJson(json as Map<String, dynamic>),
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
