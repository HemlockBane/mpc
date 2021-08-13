// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_validation_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _OnboardingValidationService implements OnboardingValidationService {
  _OnboardingValidationService(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://moniepoint-customer-operations-service-v2.console.teamapt.com/api/v2/onboarding-validation/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServiceResult<OnboardingLivelinessValidationResponse>>
      validateLivelinessForOnboarding(
          firstCapture, motionCapture, bvn, phoneNumberValidationKey) async {
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
    _data.fields.add(MapEntry('bvn', bvn));
    _data.fields
        .add(MapEntry('phoneNumberValidationKey', phoneNumberValidationKey));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceResult<OnboardingLivelinessValidationResponse>>(
            Options(
                    method: 'POST',
                    headers: <String, dynamic>{
                      r'Content-Type': 'multipart/form-data',
                      r'client-id': 'ANDROID',
                      r'appVersion': '1.0.6'
                    },
                    extra: _extra,
                    contentType: 'multipart/form-data')
                .compose(_dio.options, 'check-for-liveliness',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value =
        ServiceResult<OnboardingLivelinessValidationResponse>.fromJson(
      _result.data!,
      (json) => OnboardingLivelinessValidationResponse.fromJson(
          json as Map<String, dynamic>),
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
