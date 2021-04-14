import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/http_logging_interceptor.dart';

class ServiceModule {

  static void initService() {
    final dio = Dio()..interceptors.add(LoggingInterceptor());

    //initialize all the service/delegate here
    GetIt.I.registerLazySingleton<OnBoardingServiceDelegate>(() {
      return OnBoardingServiceDelegate(OnBoardingService(dio));
    });

    //GetIt.I.registerLazySingleton<OnBoardingServiceDelegate>(() => OnBoardingServiceDelegate(dio));

  }
}