import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/onboarding/model/account_creation_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_delegate.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_service.dart';
import 'package:moniepoint_flutter/core/network/http_logging_interceptor.dart';

class ServiceModule {

  static void initService() {
    final dio = Dio()..interceptors.add(LoggingInterceptor());

    //initialize all the service/delegate here
    GetIt.I.registerLazySingleton<OnBoardingServiceDelegate>(() {
      return OnBoardingServiceDelegate(OnBoardingService(dio), AccountCreationService(dio));
    });

    GetIt.I.registerLazySingleton<SecurityQuestionDelegate>(() {
      return SecurityQuestionDelegate(SecurityQuestionService(dio));
    });

    GetIt.I.registerLazySingleton<DeviceInfoPlugin>(() {
      return DeviceInfoPlugin();
    });

  }
}